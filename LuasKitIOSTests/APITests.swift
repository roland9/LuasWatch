//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest

@testable import LuasKitIOS

class APITests: XCTestCase {

	func testRealAPI() {
		let apiExpectation = expectation(description: "API call expectation")

		LuasAPI2.dueTime(for: stationBlueBell) { (result) in
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

		LuasMockAPI2.dueTime(for: stationBlueBell) { (result) in
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

		LuasMockErrorAPI.dueTime(for: stationBlueBell) { (result) in
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
