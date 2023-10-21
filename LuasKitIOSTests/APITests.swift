//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest

#if os(iOS)
@testable import LuasKitIOS
#endif

#if os(watchOS)
@testable import LuasKit
#endif

public struct WrongAPIWorker: APIWorker {

    public func getTrains(shortCode: String) async throws -> Data {

        let url = URL(string: "https://WRONGluasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=\(shortCode)&encrypt=false")!

        let (data, _) = try await URLSession.shared.data(from: url)

        return data
    }

    public init() {}
}

// this test class is shared between LuasKitIOSTests and the WatchKitExtensionTests

class APITests: XCTestCase {

    func testRealAPI() async throws {
        let api = LuasAPI(apiWorker: RealAPIWorker())

        let trains = try await api.dueTimes(for: stationHarcourt)

        XCTAssertEqual(trains.trainStation.name, "Harcourt")
	}

    func testWrongAPI() async {
        let api = LuasAPI(apiWorker: WrongAPIWorker())

        do {
            _ = try await api.dueTimes(for: stationHarcourt)
            XCTFail("unexpected")
        } catch {
            XCTAssertEqual(error.localizedDescription, "A server with the specified hostname could not be found.")
        }
    }

	func testMockAPI_RanelaghTrains() async throws {
        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .ranelaghTrains))

        let trains = try await api.dueTimes(for: stationHarcourt)

        XCTAssertEqual(trains.inbound.count, 2)
        XCTAssertEqual(trains.inbound[0], Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due"))
        XCTAssertEqual(trains.inbound[1], Train(destination: "Broombridge", direction: "Inbound", dueTime: "5"))

        XCTAssertEqual(trains.outbound.count, 3)
        XCTAssertEqual(trains.outbound[0], Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "7"))
        XCTAssertEqual(trains.outbound[1], Train(destination: "Sandyford", direction: "Outbound", dueTime: "9"))
        XCTAssertEqual(trains.outbound[2], Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "15"))

        XCTAssertEqual(trains.message, "Green Line services operating normally")
	}

    func testMockAPI_NoTrains() async {
        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .noTrainsButMessage))

        do {
            _ = try await api.dueTimes(for: stationHarcourt)
            XCTFail("did expect an exception")

        } catch {

            if let apiError = error as? APIError {

                switch apiError {
                    case .noTrains(let message):
                        XCTAssertEqual(message, "Green Line services operating normally")
                    default:
                        XCTFail("unexpected case")

                }
            } else {
                XCTFail("unexpected case")
            }
        }
    }

    func testMockAPI_NoTrainsNoMessage() async {
        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .noTrainsNoMessage))

        do {
            _ = try await api.dueTimes(for: stationHarcourt)
            XCTFail("did expect an exception")

        } catch {

            if let apiError = error as? APIError {

                switch apiError {
                    case .noTrains(let message):
                        XCTAssertEqual(message, "Couldn’t get any trains.\n\n" +
                                       "Either Luas is not operating, or there is a problem with the Luas website.")
                    default:
                        XCTFail("unexpected case")
                }
            } else {
                XCTFail("unexpected error type")
            }
        }
    }

    func testMockAPI_ServerError() async {
        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .serverError))

        do {
            _ = try await api.dueTimes(for: stationBluebell)
            XCTFail("did expect an exception")

        } catch {

            XCTAssertEqual((error as NSError), NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut))
        }
    }

    func testMockAPI_ParserErrorInvalidXML() async {
        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .parserError))

        do {
            _ = try await api.dueTimes(for: stationHarcourt)
            XCTFail("did expect an exception")

        } catch {

            if let apiError = error as? APIError {

                switch apiError {
                    case .invalidXML(let message):
                        XCTAssertEqual(message, "some invalid xml")
                    default:
                        XCTFail("unexpected case")
                }
            } else {
                XCTFail("unexpected error type")
            }
        }
    }
}
