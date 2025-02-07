//
//  Created by Roland Gropmair on 07/02/2025.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import Testing

@testable import LuasApp

struct AppMode_CustomStringConvertibleTests {

  @Test func appMode_CustomStringConvertible_returnsString() throws {
    var mode: AppMode = .closest
    #expect(mode.description == "closest")

    mode = .closestOtherLine
    #expect(mode.description == "closestOtherLine")

    mode = .favourite(stationBluebell)
    #expect(mode.description == "favourite: Bluebell")

    mode = .nearby(stationGreen)
    #expect(mode.description == "nearby: station name 1")

    mode = .specific(stationRed)
    #expect(mode.description == "specific: station name 2")

    mode = .recents(stationHarcourt)
    #expect(mode.description == "recents: Harcourt")
  }
}
