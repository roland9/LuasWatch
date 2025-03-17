//
//  Created by Roland Gropmair on 17/03/2025.
//  Copyright © 2025 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

#Preview("idle") {
  makeTabView(.idle)
}

#Preview("auth") {
  makeTabView(.locationAuthorizationUnknown)
}

#Preview("loading") {
  makeTabView(.loadingDueTimes(stationGreen, cachedTrains: nil))
}

#Preview("loading cache") {
  makeTabView(.loadingDueTimes(stationGreen, cachedTrains: trainsGreen))
}

#Preview("Phibs") {
  makeTabView(.foundDueTimes(trainsGreen))
}

#Preview("No trains") {
  makeTabView(.foundDueTimes(trainsNoTrains))
}

#Preview("No out") {
  makeTabView(.foundDueTimes(trainsNoOutboundTrains))
}

#Preview("Lots") {
  makeTabView(.foundDueTimes(lotsOfTrains))
}

#endif
