//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest
import CoreLocation

import LuasKitIOS

class LuasKitIOSTests: XCTestCase {

	let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
	let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
	let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

	let station = TrainStation(stationId: "stationId",
							   stationIdShort: "LUAS8",
							   route: .green,
							   name: "Bluebell",
							   location: CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2))))

	func testDueTimeDescription() {

		let trains = TrainsByDirection(trainStation: station,
									   inbound: [train3],
									   outbound: [train1, train2])

		XCTAssert(trains.inbound.count == 1)
		XCTAssert(trains.inbound[0].dueTimeDescription == "Sandyford: 12 mins")

		XCTAssert(trains.outbound.count == 2)
		XCTAssert(trains.outbound[0].dueTimeDescription == "Broombridge: Due")
		XCTAssert(trains.outbound[1].dueTimeDescription == "Broombridge: 9 mins")
	}

	func testClosestStation() {
		let allStations = TrainStations(stations: [
			TrainStation(stationId: "822GA00360",
						 stationIdShort: "LUAS8",
						 route: .red,
						 name: "Bluebell",
						 location: CLLocation(latitude: CLLocationDegrees(Double(53.3292817872831)),
											  longitude: CLLocationDegrees(Double(-6.33382500275916)))),
			TrainStation(stationId: "822GA00440",
						 stationIdShort: "LUAS25",
						 route: .green,
						 name: "Harcourt",
						 location: CLLocation(latitude: CLLocationDegrees(Double(53.3336246192981)),
											  longitude: CLLocationDegrees(Double(-6.26273785213714))))
		])

		var location = CLLocation(latitude: CLLocationDegrees(53.32928178728), longitude: CLLocationDegrees(-6.333825002759))
		XCTAssert(allStations.closestStation(from: location)!.name == "Bluebell")

		location = CLLocation(latitude: CLLocationDegrees(53.329), longitude: CLLocationDegrees(-6.333))
		XCTAssert(allStations.closestStation(from: location)!.name == "Bluebell")

		location = CLLocation(latitude: CLLocationDegrees(52.329), longitude: CLLocationDegrees(-6.333))
		XCTAssertNil(allStations.closestStation(from: location))
	}

	func testRealAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		LuasAPI.dueTime(for: station) { (result) in
			switch result {

			case .error(let message):
				print("error: \(message)")

			case .success(let trains):
				apiExpectation.fulfill()
				print(trains)
			}
		}

		wait(for: [apiExpectation], timeout: 10)
	}

	func testMockAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		/*
			[
				"destination": "LUAS Bride's Glen",
				"direction": "Outbound",
				"duetime": "Due"
			],
			[
				"destination": "LUAS Broombridge",
				"direction": "Inbound",
				"duetime": "6"
			],
			[
				"destination": "LUAS Bride's Glen",
				"direction": "Outbound",
				"duetime": "15"
			]
		*/

		LuasMockAPI.dueTime(for: station) { (result) in
			switch result {

			case .error(let message):
				print("error: \(message)")

			case .success(let trains):
				XCTAssert(trains.inbound.count == 1)
				XCTAssert(trains.inbound[0] == Train(destination: "LUAS Broombridge", direction: "Inbound", dueTime: "6"))

				XCTAssert(trains.outbound.count == 2)
				XCTAssert(trains.outbound[0] == Train(destination: "LUAS Bride's Glen", direction: "Outbound", dueTime: "Due"))
				XCTAssert(trains.outbound[1] == Train(destination: "LUAS Tallaght", direction: "Outbound", dueTime: "15"))

				apiExpectation.fulfill()
				print(trains)
			}
		}

		wait(for: [apiExpectation], timeout: 1)
	}

}
