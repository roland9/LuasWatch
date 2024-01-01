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

            Section {
                FavouritesSidebarView(selectedStation: $selectedStation)
            } header: {
                FavouritesHeaderView()
            }

            Section {
                NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(3)) +
                                   Array(TrainStations.sharedFromFile.redLineStations.prefix(3)),
                selectedStation: $selectedStation)
            } header: {
                Text("Nearby")
                    .font(.subheadline)
                    .frame(minHeight: 40)
            }

            Section {
                LinesView()
            } header: {
                Text("Lines")
                    .font(.subheadline)
                    .frame(minHeight: 40)
            } footer: {

                Text("App Version 1.0.0")
            }


//            RecentsView()

        }
        .containerBackground(.green.gradient,
                             for: .navigation)
        .listStyle(.carousel)


//      List(selection: $selectedStation) {
//            ForEach(stations, id: \.self) { station in
//                NavigationLink(station.name,
//                               value: station.name)
//            }
//        }
    }
}

#Preview("Sidebar") {
    @State var selectedStation: TrainStation?

    return SidebarView(selectedStation: $selectedStation)
        .modelContainer(Previews().container)
}
