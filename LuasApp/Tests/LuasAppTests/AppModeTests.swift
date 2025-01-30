//
//  Created by Roland Gropmair on 30/12/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Testing

@testable import LuasApp

struct AppModeTests {

  @Test func appMode_specificStation() async throws {

    var station: AppMode = .closest
    #expect(station.specificStation == nil)

    station = .closestOtherLine
    #expect(station.specificStation == nil)

    station = .favourite(stationRed)
    #expect(station.specificStation == stationRed)

    station = .nearby(stationGreen)
    #expect(station.specificStation == stationGreen)

    station = .specific(stationBluebell)
    #expect(station.specificStation == stationBluebell)

    station = .recents(stationHarcourt)
    #expect(station.specificStation == stationHarcourt)
  }

  @Test func appMode_needsLocation() async throws {

    var station: AppMode = .closest
    #expect(station.needsLocation == true)

    station = .closestOtherLine
    #expect(station.needsLocation == true)

    station = .favourite(stationRed)
    #expect(station.needsLocation == false)

    station = .nearby(stationGreen)
    #expect(station.needsLocation == false)

    station = .specific(stationBluebell)
    #expect(station.needsLocation == false)

    station = .recents(stationHarcourt)
    #expect(station.needsLocation == false)
  }
}
