//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct StationTimesView: View {
    
    @EnvironmentObject private var appModel: AppModel

    @State private var direction: Direction?

    var trains: TrainsByDirection
}

extension StationTimesView {

    var body: some View {
        NavigationStack {

            VStack {
                Text(trains.trainStation.name)
                    .font(.title3)
                    .padding(.bottom)

                Spacer()

                switch direction {

                    case .inbound:
                        SimpleTimetableView(trains: trains.inbound)

                    case .outbound:
                        SimpleTimetableView(trains: trains.outbound)

                    case .both:
                        DoubleTimetableView(trainsByDirection: trains)

                    case .none:
                        Text("None")
                }
            }
            .toolbar {
                StationToolbar(
                    direction: $direction,
                    trains: trains)
            }
        }
    }
}
