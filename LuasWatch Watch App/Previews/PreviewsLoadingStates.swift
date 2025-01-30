//
//  Created by Roland Gropmair on 14/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftUI

#if DEBUG

  #Preview("loading") {
    luasMainScreen(state: .loadingDueTimes(stationGreen, cachedTrains: nil))
  }

  #Preview("loading (cached)") {
    luasMainScreen(state: .loadingDueTimes(stationGreen, cachedTrains: trainsGreen))
  }

  #Preview("loading 1Way (cached)") {
    luasMainScreen(
      state: .loadingDueTimes(stationOneWay, cachedTrains: trainsMarlborough))
  }

  #Preview("noTrains") {
    luasMainScreen(state: .foundDueTimes(noTrainsGreen))
  }

  #Preview("OK") {
    luasMainScreen(state: .foundDueTimes(trainsGreen))
  }
#endif
