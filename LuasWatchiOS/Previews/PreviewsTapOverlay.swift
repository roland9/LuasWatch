//
//  Created by Roland Gropmair on 10/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
  // swiftlint:disable:next type_name
  struct Preview_TapOverlay: PreviewProvider {

    static var previews: some View {

      ZStack {
        LuasView()
          .environmentObject(AppState(state: .foundDueTimes(trainsRed_1_1, userLocation)))

        LuasView()
          .overlayView("Showing outbound trains only")
      }
      .previewDisplayName("Tap overlay view")
    }
  }
#endif
