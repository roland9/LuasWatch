//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct SidebarView: View {

    var body: some View {

        VStack {
            FavouritesSidebarView()

            NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(3)) +
                               Array(TrainStations.sharedFromFile.redLineStations.prefix(3)))

            LinesView()

//            RecentsView()

            Text("Version 1.0.0")
        }


//      List(selection: $selectedStation) {
//            ForEach(stations, id: \.self) { station in
//                NavigationLink(station.name,
//                               value: station.name)
//            }
//        }
//        .containerBackground(.green.gradient,
//                             for: .navigation)
//        .listStyle(.carousel)
    }
}

#Preview("Sidebar") {
    SidebarView()
        .modelContainer(Previews().container)
}
