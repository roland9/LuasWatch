//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct NearbyStationsView {

    @EnvironmentObject var appModel: AppModel
    let nearbyStations: [TrainStation]
}

extension NearbyStationsView: View {

    var body: some View {
        if !nearbyStations.isEmpty {

            ForEach(nearbyStations) { station in
                StationRowView(station: station,
                               action: { appModel.appMode = .nearby(station) })
            }

            Button(action: { appModel.appMode = .closest },
                   label: { Text("Closest station") })

            Button(action: { appModel.appMode = .closestOtherLine },
                   label: { Text("Closest other line station") })

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
    let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation, userLocation)))
    appModel.selectedStation = stationGreen

    return List {
        Section {
            NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(3)) +
                               Array(TrainStations.sharedFromFile.redLineStations.prefix(3)))
            .environmentObject(appModel)
        } header: {
            Text("Nearby")
                .font(.subheadline)
                .frame(minHeight: 40)
        }
    }
}

#Preview("Favourites (empty)") {
    @State var selectedStation: TrainStation?

    return NearbyStationsView(nearbyStations: [])
}
