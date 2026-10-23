//
//  Created by Roland Gropmair on 24/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftUI

#if DEBUG
  #Preview("No trains") {
    makeTabView(.foundDueTimes(trainsNoTrains))
  }

  #Preview("No out") {
    makeTabView(.foundDueTimes(trainsNoOutboundTrains))
  }

  #Preview("Lots") {
    makeTabView(.foundDueTimes(lotsOfTrains))
  }

  #Preview("Long name 1") {
    makeTabView(.foundDueTimes(trainLongNameOne))
  }

  #Preview("Long name 3") {
    makeTabView(.foundDueTimes(trainLongNameThree))
  }
#endif
