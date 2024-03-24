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
        let schema = Schema([FavouriteStation.self, StationDirection.self])
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

    func testDirection_StationNotStored_returns0() throws {
        XCTAssertEqual((try context.direction(for: "HAR")).count, 0)
    }

    func testDirection_StationStored_returnsCorrectValue() throws {
        let station = StationDirection(shortCode: "RAN", direction: .inbound)
        context.insert(station)
        XCTAssertEqual(try context.direction(for: "RAN").first?.direction, .inbound)
    }

    func testDirectionConsideringStationType_StationInvalid_returnsBoth() throws {
        XCTAssertEqual(context.directionConsideringStationType(for: "XYZ"), .both)
    }

    func testDirectionConsideringStationType_StationStoredButFinalStop_returnsBoth() throws {
        let station = StationDirection(shortCode: "TAL", direction: .inbound)
        context.insert(station)
        XCTAssertEqual(context.directionConsideringStationType(for: "TAL"), .both)
    }

    func testDirectionConsideringStationType_StationStored_returnsCorrectValue() throws {
        let station = StationDirection(shortCode: "RAN", direction: .inbound)
        context.insert(station)
        XCTAssertEqual(context.directionConsideringStationType(for: "RAN"), .inbound)
    }

    func testStoreDirection_createsNewRecordIfNotExist() throws {
        XCTAssertEqual(try context.direction(for: "RAN").count, 0)
        context.createOrUpdate(shortCode: "RAN", to: .inbound)

        XCTAssertEqual(try context.direction(for: "RAN").count, 1)
        let station = try context.direction(for: "RAN").first!
        XCTAssertEqual(station.direction, .inbound)
    }

    func testStoreDirection_updatesRecordIfExist() throws {
        context.createOrUpdate(shortCode: "RAN", to: .inbound)

        context.createOrUpdate(shortCode: "RAN", to: .outbound)

        XCTAssertEqual(try context.direction(for: "RAN").count, 1)
        let station = try context.direction(for: "RAN").first!
        XCTAssertEqual(station.direction, .outbound)
    }
}
