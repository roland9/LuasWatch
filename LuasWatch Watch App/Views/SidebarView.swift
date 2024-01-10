//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct SidebarView: View {

    @Binding var selectedStation: TrainStation?

    var body: some View {

        List(selection: $selectedStation) {

            /// Favourite Stations
            Section {
                FavouritesSidebarView(selectedStation: $selectedStation)
            } header: {
                FavouritesHeaderView()
            }

            /// Nearby Stations
            Section {
                NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(3)) +
                                   Array(TrainStations.sharedFromFile.redLineStations.prefix(3)))
            } header: {
                Text("Nearby")
                    .font(.subheadline)
                    .frame(minHeight: 40)
            }

            /// Lines Green / Red
            Section {
                LinesView(actionRed: {

                },
                          actionGreen: {

                })
            } header: {
                Text("Lines")
                    .font(.subheadline)
                    .frame(minHeight: 40)
            } footer: {

                Text("App Version 1.0.0")
            }

            /// Recents
//            RecentsView()

        }
        .containerBackground(Color("luasTheme").gradient,
                             for: .navigation)
        .listStyle(.carousel)
    }
}

#Preview("Sidebar") {
    @State var selectedStation: TrainStation?

    return SidebarView(selectedStation: $selectedStation)
        .modelContainer(Previews().container)
}
