//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct StationTimesView: View {

    @Environment(\.modelContext) private var modelContext

    @State private var direction: Direction = .both

    var trains: TrainsByDirection
    var isLoading: Bool = false
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
                        if trains.inbound.count > 0 {
                            SimpleTimetableView(
                                trains: trains.inbound,
                                isLoading: isLoading)
                        } else {
                            NoTrainsView()
                                .timeTableStyle()
                        }

                    case .outbound:
                        if trains.outbound.count > 0 {
                            SimpleTimetableView(
                                trains: trains.outbound,
                                isLoading: isLoading)
                        } else {
                            NoTrainsView()
                                .timeTableStyle()
                        }

                    case .both:
                        DoubleTimetableView(
                            trainsByDirection: trains,
                            isLoading: isLoading)
                }
            }

            .onAppear {
                direction = modelContext.directionConsideringStationType(for: trains.trainStation.shortCode)
            }

            .toolbar {
                StationToolbar(
                    direction: $direction,
                    trains: trains,
                    isLoading: isLoading)
            }
        }
    }
}
