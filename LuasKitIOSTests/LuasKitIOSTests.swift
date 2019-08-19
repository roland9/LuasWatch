//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest
import CoreLocation

import LuasKitIOS

class LuasKitIOSTests: XCTestCase {

	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testExample() {
		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))

		let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
		let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
		let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

		let station = TrainStation(stationId: "stationId",
								   stationIdShort: "LUAS8",
								   name: "Bluebell",
								   location: location)

		let trains = TrainsByDirection(trainStation: station,
									   inbound: [train3],
									   outbound: [train1, train2])

		XCTAssert(trains.inbound.count == 1)
		XCTAssert(trains.outbound.count == 2)

	}

}
