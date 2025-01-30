//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftUI

#if DEBUG

  #Preview("idle") {
    luasMainScreen(state: .idle)
  }

  #Preview("gettingLoc") {
    luasMainScreen(state: .gettingLocation)
  }

  #Preview("authUnk") {
    luasMainScreen(state: .locationAuthorizationUnknown)
  }

  #Preview("locErr") {
    luasMainScreen(state: .errorGettingLocation("Error getting location."))
  }

  #Preview("errStation") {
    luasMainScreen(
      state: .errorGettingStationTooFarAway(
        "Some internal error getting station."))
  }

  #Preview("errFarAway") {
    luasMainScreen(state: .errorGettingStationTooFarAway(LuasStrings.tooFarAway))
  }

  #Preview("errLoading") {
    luasMainScreen(
      state: .errorGettingDueTimes(
        stationGreen, "Error loading due times - could not access internet?"))
  }
#endif
