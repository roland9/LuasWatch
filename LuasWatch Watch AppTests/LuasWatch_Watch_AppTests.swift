//
//  Created by Roland Gropmair on 21/10/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftData
import XCTest

@testable import LuasWatch_Watch_App

final class LuasWatch_Watch_AppTests: XCTestCase {

    var context: ModelContext!

    override func setUpWithError() throws {
        let schema = Schema([FavouriteStation.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        context = ModelContext(container)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavouriteStationDoesNotExist() throws {
        XCTAssertFalse(context.doesFavouriteStationExist(shortCode: "HAR"))
    }

    func testFavouriteStationDoesExist() throws {
        let station = FavouriteStation(shortCode: "HAR")
        context.insert(station)
        XCTAssertTrue(context.doesFavouriteStationExist(shortCode: "HAR"))
    }
}
