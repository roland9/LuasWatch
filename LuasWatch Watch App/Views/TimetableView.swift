//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct SimpleTimetableView: View {

    let trains: [Train]
    var isLoading: Bool

    var body: some View {
        Spacer()

        VStack {
            ForEach(trains, id: \.id) {
                DueView(
                    destination: $0.destinationDescription, 
                    due: $0.dueTimeDescription2)
            }
        }
        .timeTableStyle()
        
        Spacer()
    }
}

struct DoubleTimetableView: View {

    let trainsByDirection: TrainsByDirection
    var isLoading: Bool

    var body: some View {

        VStack {
            ForEach(trainsByDirection.inbound, id: \.id) {
                DueView(
                    destination: $0.destinationDescription,
                    due: $0.dueTimeDescription2)
            }
            Divider()
            ForEach(trainsByDirection.outbound, id: \.id) {
                DueView(
                    destination: $0.destinationDescription,
                    due: $0.dueTimeDescription2)
            }
        }
        .timeTableStyle()
        .opacity(isLoading ? 0.52 : 1.0)
    }
}

extension View {

    fileprivate func timeTableStyle() -> some View {
        self
            .padding(6)
            .background(.black)
            .border(.secondary).cornerRadius(2)
            .padding(4)
    }
}
