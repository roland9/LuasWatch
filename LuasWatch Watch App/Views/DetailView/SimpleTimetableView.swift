//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct SimpleTimetableView: View {

    let trainsByDirection: TrainsByDirection
    let direction: Direction
}

extension SimpleTimetableView {

    var body: some View {
        var trains = [Train]()
        var hasOverflow = false
        switch direction {
            /// noOverflowLarge cuts off after 6 - WIP: show overflow in subsequent tabView
            case .inbound:
                trains = trainsByDirection.inboundNoOverflowLarge
                hasOverflow = trainsByDirection.inboundHasOverflowLarge
            case .outbound:
                trains = trainsByDirection.outboundNoOverflowLarge
                hasOverflow = trainsByDirection.outboundHasOverflowLarge
            case .both:
                assertionFailure("expected either .inbound OR .outbound - not .both")
                trains = trainsByDirection.inbound
        }

        return VStack {
            ForEach(trains, id: \.id) {
                DueView(
                    destination: $0.destinationDescription,
                    due: $0.dueTimeDescription2)
            }
            if hasOverflow {
                OverflowView()
            }
            Spacer()
        }
        .timeTableStyle()
    }
}
