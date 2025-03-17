//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

#Preview("idle") {
  makeTabView(AppModel(.idle))
}

#Preview("gettingLoc") {
  makeTabView(AppModel(.gettingLocation))
}

#Preview("authUnk") {
  makeTabView(AppModel(.locationAuthorizationUnknown))
}

#Preview("locErr") {
  makeTabView(AppModel(.errorGettingLocation("Error getting location.")))
}

#Preview("errStation") {
  makeTabView(AppModel(.errorGettingStationTooFarAway(
    "Some internal error getting station.")))
}

#Preview("errFarAway") {
  makeTabView(AppModel(.errorGettingStationTooFarAway(LuasStrings.tooFarAway)))
}

#Preview("errLoading") {
  makeTabView(AppModel(.errorGettingDueTimes(
    stationGreen, "Error loading due times - could not access internet?")))
}
#endif
