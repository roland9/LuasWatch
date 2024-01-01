//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct NearbyStationsView {

    let nearbyStations: [TrainStation]

    @Binding var selectedStation: TrainStation?

}

extension NearbyStationsView: View {

    var body: some View {
        if !nearbyStations.isEmpty {

            ForEach(nearbyStations) { station in
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
            }

            Text("Closest station")

            Text("Closest other line station")

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
    @State var selectedStation: TrainStation?

    return List {
        Section {
            NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(3)) +
                               Array(TrainStations.sharedFromFile.redLineStations.prefix(3)),
                               selectedStation: $selectedStation)
        } header: {
            Text("Nearby")
                .font(.subheadline)
                .frame(minHeight: 40)
        }
    }
}


#Preview("Favourites (empty)") {
    @State var selectedStation: TrainStation?

    return NearbyStationsView(nearbyStations: [],
                       selectedStation: $selectedStation)
}
