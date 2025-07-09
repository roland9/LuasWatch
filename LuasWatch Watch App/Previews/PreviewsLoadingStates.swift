//
//  Created by Roland Gropmair on 14/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

  #Preview("loading") {
    makeTabView(.loadingDueTimes(stationGreen, cachedTrains: nil))
  }

  #Preview("loading (cached)") {
    makeTabView(.loadingDueTimes(stationGreen, cachedTrains: trainsGreen))
  }

  #Preview("loading 1Way (cached)") {
    makeTabView(.loadingDueTimes(stationOneWay, cachedTrains: trainsMarlborough))
  }

  #Preview("noTrains") {
    makeTabView(.foundDueTimes(noTrainsGreen))
  }

  #Preview("OK") {
    makeTabView(.foundDueTimes(trainsGreen))
  }
#endif
