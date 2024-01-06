//
//  Created by Roland Gropmair on 03/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct AllStationsListView: View {

    @Environment(\.dismiss) private var dismiss
    @State var stations: [TrainStation]

    var body: some View {

        NavigationView(content: {

            ScrollView {
                NavigationLink(destination: greenStationsView()) {
                    LineRowView(route: .green)
                }

                NavigationLink(destination: redStationsView()) {
                    LineRowView(route: .red)
                }
            }
        })
        .navigationTitle("Add to favourites")
    }

    @ViewBuilder
    private func greenStationsView() -> some View {
        StationsModal(stations: TrainStations.sharedFromFile.greenLineStations,
                      dismissAllModal: { dismiss() })
        .navigationTitle("Add to favourites")
    }

    @ViewBuilder
    private func redStationsView() -> some View {
        StationsModal(stations: TrainStations.sharedFromFile.redLineStations,
                      dismissAllModal: { dismiss() })
        .navigationTitle("Add to favourites")
    }

    struct StationsModal: View {
        @Environment(\.modelContext) private var modelContext

        @State var stations: [TrainStation]

        /// challenge here: we could use Environment(\.dismiss); but that only dismisses this Stations nav view,
        /// so it's then back to StationsSelection modal.  instead, we want to dismiss the *entire* flow
        var dismissAllModal: () -> Void

        var body: some View {
            List {
                ForEach(stations, id: \.stationId) { (station) in

                    // need a button here because just text only supports tap on the text but not full width
                    Button(action: {

                        modelContext.insert(FavouriteStation(shortCode: station.shortCode))

                        DispatchQueue.main.async {
                            dismissAllModal()
                        }

                    }, label: {
                        Text(station.name)
                            .font(.system(.headline))
                    })
                }
            }
        }
    }
}

#Preview("All Stations (green)") {

    AllStationsListView(stations: TrainStations.sharedFromFile.greenLineStations)
        .modelContainer(Previews().container)
}
