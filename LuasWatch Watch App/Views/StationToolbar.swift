//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationToolbar {

    @EnvironmentObject private var appModel: AppModel
    @Environment(\.modelContext) private var modelContext

    // have to let SwiftUI know that underlying context has changed -  can we avoid the isFavourite state?
    @State private var isFavourite: Bool = false

    @State private var isSwitchingDirectionEnabled: Bool = true

    @Binding var direction: Direction?

    let trains: TrainsByDirection
}

extension StationToolbar: ToolbarContent {

    var body: some ToolbarContent {

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // Perform an action here.
            } label: {
                Image(systemName: "map")
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {

            /// Change direction
            Button {
                withAnimation {
                    direction = direction?.next()
                }
                if let direction {
                    let shortCode = trains.trainStation.shortCode
                    myPrint("\(#function) createOrUpdate \(shortCode) to \(direction)")
                    modelContext.createOrUpdate(shortCode: shortCode, to: direction)
                }
            } label: {
                switch direction {

                    case .inbound:
                        Image(systemName: "arrow.left")
                    case .outbound:
                        Image(systemName: "arrow.right")
                    case .both:
                        Image(systemName: "arrow.left.arrow.right")
                    case .none:  // because it's optional
                        Image(systemName: "arrow.left.arrow.right")
                }
            }
            .onAppear {
                isSwitchingDirectionEnabled = trains.trainStation.allowsSwitchingDirection
                direction = modelContext.directionConsideringStationType(for: trains.trainStation.shortCode)
                print("😍 on appear \(trains.trainStation.shortCode)  isSwitchingDirectionEnabled \(isSwitchingDirectionEnabled)")
            }
            // WIP
            .onChange(
                of: appModel.selectedStation,
                { oldValue, newValue in
                    print("😇 onChange old \(oldValue) \(newValue)")
                }
            )
            .disabled(!isSwitchingDirectionEnabled)

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
