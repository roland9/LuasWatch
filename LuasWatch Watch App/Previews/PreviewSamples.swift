//
//  Created by Roland Gropmair on 17/03/2025.
//  Copyright © 2025 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

#Preview("idle") {
  makeTabView(AppModel(.idle), .green)
}

#Preview("auth") {
  makeTabView(AppModel(.locationAuthorizationUnknown), .green)
}

#Preview("loading") {
  makeTabView(AppModel(.loadingDueTimes(stationGreen, cachedTrains: nil)), .green)
}

#Preview("loading cache") {
  makeTabView(AppModel(.loadingDueTimes(stationGreen, cachedTrains: trainsGreen)), .green)
}

#Preview("Phibs") {
  makeTabView(AppModel(.foundDueTimes(trainsGreen)), .green)
}

#Preview("No trains") {
  makeTabView(AppModel(.foundDueTimes(trainsNoTrains)), .green)
}

#Preview("No out") {
  makeTabView(AppModel(.foundDueTimes(trainsNoOutboundTrains)), .green)
}

#Preview("Lots") {
  makeTabView(AppModel(.foundDueTimes(lotsOfTrains)), .green)
}

#endif
