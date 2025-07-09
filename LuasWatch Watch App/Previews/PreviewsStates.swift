//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

  #Preview("idle") {
    makeTabView(.idle)
  }

  #Preview("gettingLoc") {
    makeTabView(.gettingLocation)
  }

  #Preview("authUnk") {
    makeTabView(.locationAuthorizationUnknown)
  }

  #Preview("locErr") {
    makeTabView(.errorGettingLocation("Error getting location."))
  }

  #Preview("errStation") {
    makeTabView(
      .errorGettingStationTooFarAway(
        "Some internal error getting station."))
  }

  #Preview("errFarAway") {
    makeTabView(.errorGettingStationTooFarAway(LuasStrings.tooFarAway))
  }

  #Preview("errLoading") {
    makeTabView(
      .errorGettingDueTimes(
        stationGreen, "Error loading due times - could not access internet?"))
  }
#endif
