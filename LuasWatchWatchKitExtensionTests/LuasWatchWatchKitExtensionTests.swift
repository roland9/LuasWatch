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

import LuasKit

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

	func testRealAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		LuasAPI2.dueTime(for: stationBluebell) { (result) in
			switch result {

			case .error(let message):
				print("error: \(message)")
				XCTFail("did not expect error")
				apiExpectation.fulfill()
			case .success(let trains):
				print(trains)
				apiExpectation.fulfill()
			}
		}

		wait(for: [apiExpectation], timeout: 15)
	}

	func testMockAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		/*
		<stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
		<message>Green Line services operating normally</message>
		<direction name="Inbound">
		<tram dueMins="Due" destination="Broombridge" />
		</direction>
		<direction name="Inbound">
		<tram dueMins="5" destination="Broombridge" />
		</direction>
		<direction name="Outbound">
		<tram dueMins="7" destination="Bride's Glen" />
		</direction>
		<direction name="Outbound">
		<tram dueMins="9" destination="Sandyford" />
		</direction>
		<direction name="Outbound">
		<tram dueMins="15" destination="Bride's Glen" />
		</direction>
		</stopInfo>
		*/

		LuasMockAPI2.dueTime(for: stationBluebell) { (result) in
			switch result {

			case .error(let message):
				print("error: \(message)")

			case .success(let trains):
				XCTAssertEqual(trains.inbound.count, 2)
				XCTAssertEqual(trains.inbound[0], Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due"))
				XCTAssertEqual(trains.inbound[1], Train(destination: "Broombridge", direction: "Inbound", dueTime: "5"))

				XCTAssertEqual(trains.outbound.count, 3)
				XCTAssertEqual(trains.outbound[0], Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "7"))
				XCTAssertEqual(trains.outbound[1], Train(destination: "Sandyford", direction: "Outbound", dueTime: "9"))
				XCTAssertEqual(trains.outbound[2], Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "15"))

				apiExpectation.fulfill()
				print(trains)
			}
		}

		wait(for: [apiExpectation], timeout: 1)
	}

	func testMockErrorAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		LuasMockErrorAPI.dueTime(for: stationBluebell) { (result) in
			switch result {

			case .error(let message):
				XCTAssertEqual(message, "Error getting due times from internet: The operation couldn’t be completed. (luaswatch error 100.)")
				apiExpectation.fulfill()

			case .success:
				XCTFail("did not expect success for this test case")
			}
		}

		wait(for: [apiExpectation], timeout: 1)
	}
}
