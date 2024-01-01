//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import SwiftData
import LuasKit

struct FavouritesSidebarView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \FavouriteStation.dateAdded)
    private var favouriteStations: [FavouriteStation]

    var body: some View {

        if !favouriteStations.isEmpty {
            List {

                Section {

                    ForEach(favouriteStations) { station in
                        HStack {
                            let station = TrainStations.sharedFromFile.station(shortCode: station.shortCode) ?? TrainStations.unknown

                            Text("\(station.name)")
                            Spacer()
                            Rectangle()
                                .cornerRadius(3)
                                .frame(width: 30, height: 20)
                                .foregroundColor(station.route == .red ?  Color("luasRed"): Color("luasGreen"))
                        }
                    }.onDelete(perform: { indexSet in
                        #warning("WIP - delete from favorites")
                    })

                } header: {
                    HStack {
                        Text("Favourites")
                            .font(.subheadline)
                            .frame(minHeight: 40)
                        Spacer()
                        Button(action: {
                            #warning("WIP - add from list")
                        }, label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 30)
                        })
                        .buttonStyle(.borderless)
                    }
                }
            }
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

#Preview("Favourites") {
    FavouritesSidebarView()
        .modelContainer(Previews().container)
}


#Preview("Favourites (empty)") {
    FavouritesSidebarView()
        .modelContainer(Previews(addSample: false).container)
}
