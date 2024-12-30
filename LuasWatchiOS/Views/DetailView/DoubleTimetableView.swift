//
//  Created by Roland Gropmair on 01/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftUI

struct DoubleTimetableView: View {

  @EnvironmentObject private var appModel: AppModel

  let trainsByDirection: TrainsByDirection
}

extension DoubleTimetableView {

  var body: some View {

    VStack {
      if trainsByDirection.inbound.count == 0 {
        NoTrainsView()

      } else {
        /// noOverflowSmall cuts off after 3 - WIP: show overflow in subsequent tabView
        ForEach(trainsByDirection.inboundNoOverflowSmall, id: \.id) {
          DueView(
            destination: $0.destinationDescription,
            due: $0.dueTimeDescriptionShort)
        }
        if trainsByDirection.inboundHasOverflowSmall {
          OverflowDotsView()
        }
        Spacer()
      }

      Divider()

      if trainsByDirection.outbound.count == 0 {
        NoTrainsView()

      } else {
        /// noOverflowSmall cuts off after 3 - WIP: show overflow in subsequent tabView
        ForEach(trainsByDirection.outboundNoOverflowSmall, id: \.id) {
          DueView(
            destination: $0.destinationDescription,
            due: $0.dueTimeDescriptionShort)
        }
        if trainsByDirection.outboundHasOverflowSmall {
          OverflowDotsView()
        }
        Spacer()
      }
    }
    .timeTableStyle()
    .opacity(appModel.appState.isLoading ? 0.52 : 1.0)
  }
}
