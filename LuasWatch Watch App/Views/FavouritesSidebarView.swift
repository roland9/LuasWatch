//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct FavouritesSidebarView {

    @EnvironmentObject var appModel: AppModel
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \FavouriteStation.dateAdded, order: .reverse)
    private var favouriteStations: [FavouriteStation]
}

extension FavouritesSidebarView: View {

    var body: some View {

        if !favouriteStations.isEmpty {

            ForEach(favouriteStations) { station in

                let station = TrainStations.sharedFromFile.station(shortCode: station.shortCode) ?? TrainStations.unknown

                StationRowView(
                    station: station,
                    action: {
                        appModel.appMode = .favourite(station)
                    })

            }.onDelete(perform: { indexSet in

                if let index = indexSet.first,
                    let item = favouriteStations[safe: index]
                {
                    modelContext.delete(item)
                }
            })

        } else {

            VStack {
                Text("No favourite stations yet")
                    .font(.title3)
                    .padding()
                    .foregroundColor(.primary)
                Text("Add one by tapping the plus button")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }

        }
    }
}

#warning("improvie visuals - nested header??")

#Preview("Favourites") {
    let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation)))
    appModel.appMode = .favourite(stationGreen)

    return List {
        Section {
            FavouritesSidebarView()
        } header: {
            FavouritesHeaderView()
        }
        .environmentObject(appModel)
        .modelContainer(Previews().container)
    }
}

#Preview("Favourites (empty)") {

    return List {
        Section {
            FavouritesSidebarView()
        } header: {
            FavouritesHeaderView()
        }
        .modelContainer(Previews(addSample: false).container)
    }
}
