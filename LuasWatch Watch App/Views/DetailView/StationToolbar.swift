//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationToolbar {

    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject private var appModel: AppModel

    // have to let SwiftUI know that underlying context has changed -  can we avoid the isFavourite state?
    @State private var isFavourite: Bool = false

    @State private var isSwitchingDirectionEnabled: Bool = true

    @Binding var direction: Direction

    let trains: TrainsByDirection
}

extension StationToolbar: ToolbarContent {

    var body: some ToolbarContent {

        // for now: hide Map button
        //        ToolbarItem(placement: .topBarTrailing) {
        //            Button {
        //                // Perform an action here.
        //            } label: {
        //                Image(systemName: "map")
        //            }
        //        }

        ToolbarItemGroup(placement: .bottomBar) {

            /// Change direction
            Button {
                withAnimation {
                    direction = direction.next()
                }

                let shortCode = trains.trainStation.shortCode
                myPrint("\(#function) createOrUpdate \(shortCode) to \(direction)")
                modelContext.createOrUpdate(shortCode: shortCode, to: direction)

            } label: {

                if trains.trainStation.allowsSwitchingDirection {

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
            .onAppear {
                isSwitchingDirectionEnabled = trains.trainStation.allowsSwitchingDirection
            }
            .disabled(!isSwitchingDirectionEnabled)

            if appModel.appState.isLoading {
                Text(LuasStrings.loadingDueTimes)
                    .font(.subheadline)
            }

            /// Favourite
            Button {
                modelContext.toggleFavouriteStation(shortCode: trains.trainStation.shortCode)
                isFavourite.toggle()
            } label: {
                isFavourite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
            }
            .onAppear {
                isFavourite = modelContext.doesFavouriteStationExist(shortCode: trains.trainStation.shortCode)
            }
        }
    }
}
