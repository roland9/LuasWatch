//
//  Created by Roland Gropmair on 25/06/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import XCTest
import CoreLocation

// unfortunately https://github.com/pointfreeco/swift-snapshot-testing doesn't support watchOS :'(
// https://github.com/pointfreeco/swift-snapshot-testing/blob/main/Package.swift
// import SnapshotTesting
// so we cannot run the snapshot tests on watchOS; but we can run the API tests!

@testable import LuasKit

fileprivate extension TrainStations {
	func station(named: String) -> TrainStation {
		stations.filter({ $0.name == named }).first!
	}
}

class LuasWatchWatchKitExtensionTests: XCTestCase {

	let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "DUE")
	let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
	let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

	let stationBluebell = TrainStation(stationId: "822GA00360",
									   stationIdShort: "LUAS8",
									   shortCode: "BLU",
									   route: .red,
									   name: "Bluebell",
									   location: CLLocation(latitude: 53.3292817872831,
															longitude: -6.33382500275916))
	let stationHarcourt = TrainStations.sharedFromFile.station(named: "Harcourt")
	let stationWestmoreland = TrainStations.sharedFromFile.station(named: "Westmoreland")

	func testDueTimeDescription() {
		let trains = TrainsByDirection(trainStation: stationBluebell,
									   inbound: [train3],
									   outbound: [train1, train2])

		XCTAssertEqual(trains.inbound.count, 1)
		XCTAssertEqual(trains.inbound[0].dueTimeDescription, "Sandyford: 12 mins")

		XCTAssertEqual(trains.outbound.count, 2)
		XCTAssertEqual(trains.outbound[0].dueTimeDescription, "Broombridge: Due")
		XCTAssertEqual(trains.outbound[1].dueTimeDescription, "Broombridge: 9 mins")
	}

	func testClosestStation() {
		let allStations = TrainStations(stations: [stationBluebell, stationHarcourt])

		var location = CLLocation(latitude: 53.32928178728, longitude: -6.333825002759)
		XCTAssertEqual(allStations.closestStation(from: location)?.name, "Bluebell")

		location = CLLocation(latitude: 53.329, longitude: -6.333)
		XCTAssertEqual(allStations.closestStation(from: location)?.name, "Bluebell")

		location = CLLocation(latitude: 53.1, longitude: -6.333)
		XCTAssertNil(allStations.closestStation(from: location))
	}

	func testClosestStationFromOtherLine() {
		let allStations = TrainStations.sharedFromFile
		XCTAssertEqual(allStations.stations.count, 67)

		let locationNearWestmoreland =
		CLLocation(latitude: stationWestmoreland.location.coordinate.latitude + 0.001,
				   longitude: stationWestmoreland.location.coordinate.longitude + 0.001)
		XCTAssertEqual(allStations.closestStation(from: locationNearWestmoreland)?.name,
					   "Westmoreland")

		XCTAssertEqual(allStations.closestStation(from: locationNearWestmoreland, route: .green)?.name,
					   "Westmoreland")
		XCTAssertEqual(allStations.closestStation(from: locationNearWestmoreland, route: .red)?.name,
					   "Abbey Street")
	}

    func testRealAPI() async {

        let result = await LuasAPI.dueTimes(for: stationBluebell)

        switch result {

            case .failure(let apiError):
                XCTFail("did not expect error: \(apiError.localizedDescription)")

            case .success(let trains):
                XCTAssertEqual(trains.trainStation.name, "Bluebell")
        }
    }

    func testMockAPI_RanelaghTrains() async {

        LuasMockAPI.scenario = .ranelaghTrains
        let result = await LuasMockAPI.dueTimes(for: stationBluebell)

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

        LuasMockAPI.scenario = .noTrainsButMessage
        let result = await LuasMockAPI.dueTimes(for: stationBluebell)

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

        LuasMockAPI.scenario = .noTrainsNoMessage
        let result = await LuasMockAPI.dueTimes(for: stationBluebell)

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

        LuasMockAPI.scenario = .serverError
        let result = await LuasMockAPI.dueTimes(for: stationBluebell)

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
