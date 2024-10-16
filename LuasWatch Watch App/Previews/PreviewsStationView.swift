//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
  #Preview("Phibs (not fav)") {
    makeTabView(AppModel(.foundDueTimes(trainsGreen)), .green)
  }

  #Preview("1/1") {
    makeTabView(AppModel(.foundDueTimes(trainsRed_1_1)), .red)
  }

  #Preview("2/1") {
    makeTabView(AppModel(.foundDueTimes(trainsRed_2_1)), .red)
  }

  #Preview("3/2") {
    makeTabView(AppModel(.foundDueTimes(trainsRed_3_2)), .red)
  }

  #Preview("4/4") {
    makeTabView(AppModel(.foundDueTimes(trainsRed_4_4)), .red)
  }

  #Preview("0/4") {
    makeTabView(AppModel(.foundDueTimes(trainsRed_0_4)), .red)
  }

  #Preview("7/7") {
    makeTabView(AppModel(.foundDueTimes(trainsRed_7_7)), .red)
  }

  #Preview("OneWay") {
    makeTabView(AppModel(.foundDueTimes(trainsOneWayStation)), .green)
  }

  #Preview("Final") {
    makeTabView(AppModel(.foundDueTimes(trainsFinalStop)), .red)
  }
#endif
