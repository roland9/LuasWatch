//
//  Created by Roland Gropmair on 03/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct AllStationsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var stations: [TrainStation]

    var body: some View {

        NavigationView(content: {

            ScrollView {
                NavigationLink(destination: stationsListView(stations: TrainStations.sharedFromFile.greenLineStations)) {
                    LineRowView(route: .green)
                }

                NavigationLink(destination: stationsListView(stations: TrainStations.sharedFromFile.redLineStations)) {
                    LineRowView(route: .red)
                }
            }
        })
        .navigationTitle("Add to favourites")
    }

    @ViewBuilder
    private func stationsListView(stations: [TrainStation]) -> some View {
        StationsModal(
            stations: stations,
            action: {
                #warning("how to avoid duplicates?")
                modelContext.insert(FavouriteStation(shortCode: $0.shortCode))

                DispatchQueue.main.async {
                    dismiss()
                }
            }
        )
        .navigationTitle("Add to favourites")
    }
}

struct StationsModal: View {

    @State var stations: [TrainStation]

    var action: (TrainStation) -> Void

    var body: some View {
        List {
            ForEach(stations, id: \.stationId) { (station) in

                // need a button here because just text only supports tap on the text but not full width
                Button(
                    action: {
                        action(station)
                    },
                    label: {
                        Text(station.name)
                            .font(.system(.headline))
                    })
            }
        }
    }
}

#Preview("All Stations (green)") {

    AllStationsListView(stations: TrainStations.sharedFromFile.greenLineStations)
        .modelContainer(Previews().container)
}
