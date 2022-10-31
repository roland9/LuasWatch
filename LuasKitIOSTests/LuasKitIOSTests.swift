//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest
import CoreLocation
import SnapshotTesting

import LuasKitIOS

fileprivate extension TrainStations {
	func station(named: String) -> TrainStation {
		stations.filter({ $0.name == named }).first!
	}
}

let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)),
						  longitude: CLLocationDegrees(Double(1.2)))

let stationBlueBell = TrainStation(stationId: "822GA00360",
								   stationIdShort: "LUAS8",
								   shortCode: "BLU",
								   route: .red,
								   name: "Bluebell",
								   location: CLLocation(latitude: CLLocationDegrees(Double(53.3292817872831)),
														longitude: CLLocationDegrees(Double(-6.33382500275916))))
let stationHarcourt = TrainStation(stationId: "822GA00440",
								   stationIdShort: "LUAS25",
								   shortCode: "HAR",
								   route: .green,
								   name: "Harcourt",
								   location: CLLocation(latitude: CLLocationDegrees(Double(53.3336246192981)),
														longitude: CLLocationDegrees(Double(-6.26273785213714))))

let trainRed1 = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "Due")
let trainRed2 = Train(destination: "LUAS Tallaght", direction: "Outbound", dueTime: "9")
let trainRed3 = Train(destination: "LUAS Connolly", direction: "Inbound", dueTime: "12")

let stationRed = TrainStation(stationId: "stationId",
							  stationIdShort: "LUAS8",
							  shortCode: "BLU",
							  route: .red,
							  name: "Bluebell",
							  location: location)

let trainsRed_1_1 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed3],
									  outbound: [trainRed2])
let trainsRed_2_1 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed3],
									  outbound: [trainRed2])
let trainsRed_3_2 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed2, trainRed3],
									  outbound: [trainRed1, trainRed2])
let trainsRed_4_4 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed2, trainRed3, trainRed3],
									  outbound: [trainRed1, trainRed2, trainRed3, trainRed3])

class LuasKitIOSTests: XCTestCase {

	let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "DUE")
	let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
	let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

	let station = TrainStation(stationId: "stationId",
							   stationIdShort: "LUAS8",
							   shortCode: "BLU",
							   route: .green,
							   name: "Bluebell",
							   location: CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2))))

	func testDueTimeDescription() {

		let trains = TrainsByDirection(trainStation: station,
									   inbound: [train3],
									   outbound: [train1, train2])

		XCTAssertEqual(trains.inbound.count, 1)
		XCTAssertEqual(trains.inbound[0].dueTimeDescription, "Sandyford: 12 mins")

		XCTAssertEqual(trains.outbound.count, 2)
		XCTAssertEqual(trains.outbound[0].dueTimeDescription, "Broombridge: Due")
		XCTAssertEqual(trains.outbound[1].dueTimeDescription, "Broombridge: 9 mins")
	}

	func testClosestStation() {
		let allStations = TrainStations(stations: [stationBlueBell,stationHarcourt])

		var location = CLLocation(latitude: CLLocationDegrees(53.32928178728), longitude: CLLocationDegrees(-6.333825002759))
		XCTAssertEqual(allStations.closestStation(from: location)!.name, "Bluebell")

		location = CLLocation(latitude: CLLocationDegrees(53.329), longitude: CLLocationDegrees(-6.333))
		XCTAssertEqual(allStations.closestStation(from: location)!.name, "Bluebell")

		location = CLLocation(latitude: CLLocationDegrees(53.1), longitude: CLLocationDegrees(-6.333))
		XCTAssertNil(allStations.closestStation(from: location))
	}
	
	func testDistanceFromUserLocation() {
		let locationNearHarcourt =
		CLLocation(latitude: stationHarcourt.location.coordinate.latitude + 0.001,
				   longitude: stationHarcourt.location.coordinate.longitude + 0.001)
		
		XCTAssertEqual(stationHarcourt.distance(from: locationNearHarcourt),
					   CLLocationDistance(floatLiteral: 129),
					   accuracy: 1)
	}

	func testRealAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		LuasAPI2.dueTime(for: station) { (result) in
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

		LuasMockAPI2.dueTime(for: station) { (result) in
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

					XCTAssertEqual(trains.message, "Green Line services operating normally")

					apiExpectation.fulfill()
					print(trains)
			}
		}

		wait(for: [apiExpectation], timeout: 1)
	}

	func testMockErrorAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		LuasMockErrorAPI.dueTime(for: station) { (result) in
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

	func testSnapshot() {

		let shouldRecord = false

		let view = LuasView()
			.environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8),
												  traits: .init(userInterfaceStyle: .light)), named: "iPhone8 tooFarAway", record: shouldRecord)

		let viewTrains = LuasView()
			.environmentObject(AppState(state: .foundDueTimes(trainsRed_2_1, location)))
		assertSnapshot(matching: viewTrains, as: .image(layout: .device(config: .iPhone8),
														traits: .init(userInterfaceStyle: .light)), named: "iPhone8 trains", record: shouldRecord)

//		let viewError = LuasView()
//			.environmentObject(
//				AppState(state: .errorGettingDueTimes(String(format: LuasStrings.emptyDueTimesErrorMessage, "Cabra"))))
//			.environment(\.sizeCategory, .extraExtraLarge)
//		assertSnapshot(matching: viewError, as: .image(layout: .device(config: .iPhone8),
//													   traits: .init(userInterfaceStyle: .light)), named: "iPhone8 errorEmpty", record: shouldRecord)

	}
}
