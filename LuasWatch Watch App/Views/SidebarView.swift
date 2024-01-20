//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct SidebarView: View {

    @EnvironmentObject var appModel: AppModel

    @Binding var selectedStation: TrainStation?

    @State var isGreenStationsViewPresented = false
    @State var isRedStationsViewPresented = false

    var body: some View {

        List(selection: $selectedStation) {

            /// Favourite Stations
            Section {
                FavouritesSidebarView()
            } header: {
                FavouritesHeaderView()
            }

            /// Nearby Stations
            Section {
                NearbyStationsView(nearbyStations: Array(TrainStations.sharedFromFile.greenLineStations.prefix(2)) +
                                   Array(TrainStations.sharedFromFile.redLineStations.prefix(2)))
            } header: {
                Text("Nearby")
                    .font(.subheadline)
                    .frame(minHeight: 40)
            }

            /// Lines Green / Red
            Section {
                LinesView(
                    actionGreen: {
                        isGreenStationsViewPresented = true
                    },
                    actionRed: {
                        isRedStationsViewPresented = true
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
        .sheet(isPresented: $isGreenStationsViewPresented, content: {
            StationsModal(stations: TrainStations.sharedFromFile.greenLineStations,
                          action: {
                appModel.appMode = .specific($0)
                isGreenStationsViewPresented = false
            })
        })
        .sheet(isPresented: $isRedStationsViewPresented, content: {
            StationsModal(stations: TrainStations.sharedFromFile.redLineStations,
                          action: {
                appModel.appMode = .specific($0)
                isRedStationsViewPresented = false
            })
        }).containerBackground(Color("luasTheme").gradient,
                               for: .navigation)
        .listStyle(.carousel)
    }
}

#Preview("Sidebar") {
    let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation, userLocation)))
    appModel.appMode = .favourite(stationGreen)
    @State var selectedStation: TrainStation?

    return SidebarView(selectedStation: $selectedStation)
        .environmentObject(appModel)
        .modelContainer(Previews().container)
}
