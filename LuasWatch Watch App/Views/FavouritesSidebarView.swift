//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import SwiftData
import LuasKit

struct FavouritesSidebarView: View {

    @Binding var selectedStation: TrainStation?

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \FavouriteStation.dateAdded)
    private var favouriteStations: [FavouriteStation]

    var body: some View {

        if !favouriteStations.isEmpty {

            ForEach(favouriteStations) { station in
                
                let station = TrainStations.sharedFromFile.station(shortCode: station.shortCode) ?? TrainStations.unknown

                HStack {

                    Text("\(station.name)")
                    Spacer()
                    Rectangle()
                        .cornerRadius(3)
                        .frame(width: 30, height: 20)
                        .foregroundColor(station.route == .red ?  Color("luasRed"): Color("luasGreen"))
                }.onTapGesture {
                    selectedStation = station
                }

            }.onDelete(perform: { indexSet in

                if let index = indexSet.first,
                   let item = favouriteStations[safe: index] {
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

    @State var selectedStation: TrainStation?

    return List {
        Section {
            FavouritesSidebarView(selectedStation: $selectedStation)
        } header: {
            FavouritesHeaderView()
        }
        .modelContainer(Previews().container)
    }
}

#Preview("Favourites (empty)") {

    @State var selectedStation: TrainStation?

    return List {
        Section {
            FavouritesSidebarView(selectedStation: $selectedStation)
        } header: {
            FavouritesHeaderView()
        }
        .modelContainer(Previews(addSample: false).container)
    }
}
