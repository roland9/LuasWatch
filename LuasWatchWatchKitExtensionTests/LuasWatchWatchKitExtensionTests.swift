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

// NB we have the ModelsTests and APITests shared into this test target!

class LuasWatchWatchKitExtensionTests: XCTestCase {

}
