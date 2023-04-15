//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest

@testable import LuasKitIOS

class APITests: XCTestCase {

    func testRealAPI() async {

        let api = LuasAPI(apiWorker: RealAPIWorker())
        let result = await api.dueTimes(for: stationHarcourt)

        switch result {

            case .failure(let apiError):

                switch apiError {
                    case .noTrains(let message):
                        print("noTrains: " + message)
                    case .serverFailure(let message):
                        print("serverFailure: " + message)
                    case .parserError(let parserError):
                        print("parserError: " + parserError.localizedDescription)
                }
                XCTFail("did not expect error: \(apiError.localizedDescription)")

            case .success(let trains):
                XCTAssertEqual(trains.trainStation.name, "Bluebell")
        }
	}

	func testMockAPI_RanelaghTrains() async {

        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .ranelaghTrains))
        let result = await api.dueTimes(for: stationHarcourt)

        switch result {

            case .failure(let apiError):
                XCTFail("did not expect error: \(apiError.localizedDescription)")

            case .success(let trains):
                XCTAssertEqual(trains.inbound.count, 2)
                XCTAssertEqual(trains.inbound[0], Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due"))
                XCTAssertEqual(trains.inbound[1], Train(destination: "Broombridge", direction: "Inbound", dueTime: "5"))

                XCTAssertEqual(trains.outbound.count, 3)
                XCTAssertEqual(trains.outbound[0], Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "7"))
                XCTAssertEqual(trains.outbound[1], Train(destination: "Sandyford", direction: "Outbound", dueTime: "9"))
                XCTAssertEqual(trains.outbound[2], Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "15"))

                XCTAssertEqual(trains.message, "Green Line services operating normally")
		}
	}

    func testMockAPI_NoTrains() async {

        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .noTrainsButMessage))
        let result = await api.dueTimes(for: stationBluebell)

        switch result {

            case .failure(let apiError):
                switch apiError {
                    case .noTrains(let message):
                        XCTAssertEqual(message, "Green Line services operating normally")
                    case .serverFailure:
                        XCTFail("did not expect this case")
                    case .parserError:
                        XCTFail("did not expect this case")
                }

            case .success(let trains):
                XCTFail("did not expect trains \(trains)")
        }
    }

    func testMockAPI_NoTrainsNoMessage() async {

        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .noTrainsNoMessage))
        let result = await api.dueTimes(for: stationBluebell)

        switch result {

            case .failure(let apiError):
                switch apiError {
                    case .noTrains(let message):
                        // no message from API: should have fallback message
                        XCTAssertEqual(message, "Couldn’t get any trains.\n\n" +
                                       "Either Luas is not operating, or there is a problem with the Luas website.")
                    case .serverFailure:
                        XCTFail("did not expect this case")
                    case .parserError:
                        XCTFail("did not expect this case")
                }

            case .success(let trains):
                XCTFail("did not expect trains \(trains)")
        }
    }

    func testMockAPI_ServerError() async {

        let api = LuasAPI(apiWorker: MockAPIWorker(scenario: .serverError))
        let result = await api.dueTimes(for: stationBluebell)

        switch result {

            case .failure(let apiError):
                switch apiError {
                    case .noTrains:
                        XCTFail("did not expect this case")
                    case .serverFailure(let message):
                        XCTAssertEqual(message, "Couldn’t get any trains.\n\n" +
                                       "Either Luas is not operating, or there is a problem with the Luas website.")
                    case .parserError:
                        XCTFail("did not expect this case")
                }

            case .success(let trains):
                XCTFail("did not expect trains \(trains)")
        }
    }
}
