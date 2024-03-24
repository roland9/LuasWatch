//
//  Created by Roland Gropmair on 03/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct AllStationsListView {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var stations: [TrainStation]
}

extension AllStationsListView: View {

    var body: some View {

        NavigationView(content: {

            ScrollView {
                NavigationLink(destination: stationsListView(stations: TrainStations.sharedFromFile.greenLineStations)) {
                    LineRow(route: .green, isHighlighted: false)
                }

                NavigationLink(destination: stationsListView(stations: TrainStations.sharedFromFile.redLineStations)) {
                    LineRow(route: .red, isHighlighted: false)
                }
            }
        })
        .navigationTitle("Add to favourites")
    }

    @ViewBuilder
    private func stationsListView(stations: [TrainStation]) -> some View {
        StationsModal(
            stations: stations,
            action: { station in

                if modelContext.doesFavouriteStationExist(shortCode: station.shortCode) == false {
                    modelContext.insert(FavouriteStation(shortCode: station.shortCode))
                } else {
                    myPrint("Favourite station already exists -> ignore")
                }

                DispatchQueue.main.async {
                    dismiss()
                }
            }
        )
        .navigationTitle("Add to favourites")
    }
}

#Preview("All Stations (green)") {

    AllStationsListView(stations: TrainStations.sharedFromFile.greenLineStations)
        .modelContainer(Previews().container)
}
