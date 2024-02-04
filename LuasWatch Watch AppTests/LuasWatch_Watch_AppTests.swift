//
//  Created by Roland Gropmair on 21/10/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import XCTest
@testable import LuasWatch_Watch_App

final class LuasWatch_Watch_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavouriteStation() throws {
        XCTAssertTrue(FavouriteStation.doesExist(shortCode: "RAN"))
    }
}
