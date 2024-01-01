//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct NearbyStationsView {

    let nearbyStations: [TrainStation]
}

extension NearbyStationsView: View {

    var body: some View {
        if !nearbyStations.isEmpty {
            List {

                Section {

                    ForEach(nearbyStations) { station in
                        HStack {
                            Text("\(station.name)")
                            Spacer()
                            Rectangle()
                                .cornerRadius(3)
                                .frame(width: 30, height: 20)
                                .foregroundColor(station.route == .red ?  Color("luasRed"): Color("luasGreen"))
                        }
                    }

                } header: {
                    Text("Nearby")
                        .font(.subheadline)
                        .frame(minHeight: 40)
                }
            }
        } else {

            VStack {
                Text("No nearby stations found")
                    .font(.title3)
                    .padding()
                    .foregroundColor(.primary)
            }

        }

    }
}

#Preview("Nearby") {
    NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(3)) +
                       Array(TrainStations.sharedFromFile.redLineStations.prefix(3))
    )
}


#Preview("Favourites (empty)") {
    NearbyStationsView(nearbyStations: [])
}
