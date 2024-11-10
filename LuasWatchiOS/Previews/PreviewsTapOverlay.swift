//
//  Created by Roland Gropmair on 10/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
  #Preview("tapOverlay") {
    ZStack {
      LuasMainScreen()
        .environmentObject(
          makeAppModel(state: .foundDueTimes(trainsRed_1_1)))

//      LuasMainScreen()
//        .overlayView("Showing outbound trains only")
    }
  }
#endif
