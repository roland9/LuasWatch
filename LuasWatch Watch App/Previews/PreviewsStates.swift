//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG

  #Preview("idle") {
    luasView(state: .idle)
  }

  #Preview("gettingLoc") {
    luasView(state: .gettingLocation)
  }

  #Preview("authUnk") {
    luasView(state: .locationAuthorizationUnknown)
  }

  #Preview("locErr") {
    luasView(state: .errorGettingLocation("Error getting location."))
  }

  #Preview("errStation") {
    luasView(
      state: .errorGettingStationTooFarAway(
        "Some internal error getting station."))
  }

  #Preview("errFarAway") {
    luasView(state: .errorGettingStationTooFarAway(LuasStrings.tooFarAway))
  }

  #Preview("errLoading") {
    luasView(
      state: .errorGettingDueTimes(
        stationGreen, "Error loading due times - could not access internet?"))
  }
#endif
