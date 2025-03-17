//
//  Created by Roland Gropmair on 14/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

#Preview("loading") {
  makeTabView(AppModel(.loadingDueTimes(stationGreen, cachedTrains: nil)))
}

#Preview("loading (cached)") {
  makeTabView(AppModel(.loadingDueTimes(stationGreen, cachedTrains: trainsGreen)))
}

#Preview("loading 1Way (cached)") {
  makeTabView(AppModel(.loadingDueTimes(stationOneWay, cachedTrains: trainsMarlborough)))
}

#Preview("noTrains") {
  makeTabView(AppModel(.foundDueTimes(noTrainsGreen)))
}

#Preview("OK") {
  makeTabView(AppModel(.foundDueTimes(trainsGreen)))
}
#endif
