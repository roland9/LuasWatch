//
//  Created by Roland Gropmair on 01/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct DoubleTimetableView: View {

    let trainsByDirection: TrainsByDirection
    var isLoading: Bool
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
                        due: $0.dueTimeDescription2)
                }
                if trainsByDirection.inboundHasOverflowSmall {
                    OverflowView()
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
                        due: $0.dueTimeDescription2)
                }
                if trainsByDirection.outboundHasOverflowSmall {
                    OverflowView()
                }
                Spacer()
            }
        }
        .timeTableStyle()
        .opacity(isLoading ? 0.52 : 1.0)
    }
}
