//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import XCTest

@testable import LuasKitIOS

class APITests: XCTestCase {

    func testRealAPI() async {

		let result = await LuasAPI.dueTimes(for: stationBlueBell)

        switch result {

            case .error(let message):
                XCTFail("did not expect error: \(message)")

            case .success(let trains):
                XCTAssertEqual(trains.trainStation.name, "Bluebell")
        }
	}

	func testMockAPI_RanelaghTrains() async {

        LuasMockAPI.scenario = .ranelaghTrains
		let result = await LuasMockAPI.dueTimes(for: stationBlueBell)

        switch result {

            case .error(let message):
                XCTFail("did not expect error: \(message)")

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
        let result = await LuasMockAPI.dueTimes(for: stationBlueBell)

        switch result {

            case .error(let message):
                XCTAssertEqual(message, "Green Line services operating normally")

            case .success(let trains):
                XCTFail("did not expect trains \(trains)")
        }
    }

    func testMockAPI_NoTrainsNoMessage() async {

        LuasMockAPI.scenario = .noTrainsNoMessage
        let result = await LuasMockAPI.dueTimes(for: stationBlueBell)

        switch result {

            case .error(let message):
                // no message from API: should have fallback message
                XCTAssertEqual(message, "Couldn’t get any trains.\n\n" +
                               "Either Luas is not operating, or there is a problem with the Luas website.")

            case .success(let trains):
                XCTFail("did not expect trains \(trains)")
        }
    }

    func testMockAPI_ServerError() async {

        LuasMockAPI.scenario = .serverError
        let result = await LuasMockAPI.dueTimes(for: stationBlueBell)

        switch result {
                
            case .error(let message):
                XCTAssertEqual(message, "Error getting results from server: The operation couldn’t be completed. (LuasKitIOS.LuasMockAPI2.LuasError error 0.)")

            case .success(let trains):
                XCTFail("did not expect trains \(trains)")
        }
    }

    // WIP convert to async/await - but it's an old API
//	func testMockErrorAPI() {
//		let apiExpectation = expectation(description: "API call expectation")
//
//		LuasMockErrorAPI.dueTime(for: stationBlueBell) { (result) in
//			switch result {
//
//				case .error(let message):
//					XCTAssertEqual(message, "Error getting due times from internet: The operation couldn’t be completed. (luaswatch error 100.)")
//					apiExpectation.fulfill()
//
//				case .success:
//					XCTFail("did not expect success for this test case")
//			}
//		}
//
//		wait(for: [apiExpectation], timeout: 1)
//	}
}
