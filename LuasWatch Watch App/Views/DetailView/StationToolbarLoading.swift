//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationToolbarLoading {

  var isFavourite: Bool
  var direction: Direction
  var isSwitchingDirectionEnabled: Bool
}

extension StationToolbarLoading: ToolbarContent {

  var body: some ToolbarContent {

    ToolbarItemGroup(placement: .bottomBar) {

      /// Change direction
      Button {
        // nop
      } label: {

        if isSwitchingDirectionEnabled {

          switch direction {
          case .inbound:
            Image(systemName: "arrow.left")
          case .outbound:
            Image(systemName: "arrow.right")
          case .both:
            Image(systemName: "arrow.left.arrow.right")
          }

        } else {
          // if station is terminal or a one way stop: show hard coded arrow; we disable the button below
          Image(systemName: "arrow.right")
        }
      }
      .disabled(!isSwitchingDirectionEnabled)

      Text(LuasStrings.loadingDueTimes)
        .font(.subheadline)

      /// Favourite
      isFavourite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
    }
  }
}
