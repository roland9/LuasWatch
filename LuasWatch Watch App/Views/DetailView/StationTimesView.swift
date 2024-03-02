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

    let trains: TrainsByDirection
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

                if trains.trainStation.allowsSwitchingDirection {

                    switch direction {

                        case .inbound:
                            if trains.inbound.isEmpty {
                                NoTrainsView()
                                    .timeTableStyle()
                            } else {
                                SimpleTimetableView(
                                    trainsByDirection: trains, direction: .inbound)
                            }

                        case .outbound:
                            if trains.outbound.isEmpty {
                                NoTrainsView()
                                    .timeTableStyle()
                            } else {
                                SimpleTimetableView(
                                    trainsByDirection: trains, direction: .outbound)
                            }

                        case .both:
                            DoubleTimetableView(
                                trainsByDirection: trains, isLoading: isLoading)
                    }

                } else {

                    // we have a .terminal or .oneway station -> only show the inbound or outbound trains
                    if !trains.inbound.isEmpty {

                        SimpleTimetableView(
                            trainsByDirection: trains, direction: .inbound)

                    } else if !trains.outbound.isEmpty {

                        SimpleTimetableView(
                            trainsByDirection: trains, direction: .outbound)

                    } else {

                        NoTrainsView()
                            .timeTableStyle()
                    }

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
