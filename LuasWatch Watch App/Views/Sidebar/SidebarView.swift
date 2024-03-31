//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct SidebarView {

    @EnvironmentObject var appModel: AppModel

    @Binding var selectedStation: TrainStation?

    @State var isGreenStationsViewPresented = false
    @State var isRedStationsViewPresented = false
}

extension SidebarView: View {

    var body: some View {

        List(selection: $selectedStation) {

            /// Favourite Stations
            Section {
                FavouritesSidebarView()
            } header: {
                FavouritesHeaderView()
            }

            /// Nearby
            Section {
                NearbyStationsView()
            } header: {
                Text("Nearby")
                    .font(.subheadline)
                    .frame(minHeight: 40)
            } footer: {

                if appModel.locationDenied {
                    Text(LuasStrings.locationDeniedFooter)
                }

                if case .errorGettingStationTooFarAway = appModel.appState {
                    Text(LuasStrings.tooFarAway)
                }
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

                let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "(unknown)"
                let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

                Text("\nApp Version \(shortVersion) (\(buildNumber))")
            }

            /// Recents
            //            RecentsView()

        }
        .sheet(
            isPresented: $isGreenStationsViewPresented,
            content: {
                StationsModal(
                    stations: TrainStations.sharedFromFile.greenLineStations,
                    action: {
                        appModel.appMode = .specific($0)
                        isGreenStationsViewPresented = false
                    })
            }
        )
        .sheet(
            isPresented: $isRedStationsViewPresented,
            content: {
                StationsModal(
                    stations: TrainStations.sharedFromFile.redLineStations,
                    action: {
                        appModel.appMode = .specific($0)
                        isRedStationsViewPresented = false
                    })
            }
        ).containerBackground(
            Color("luasTheme").gradient,
            for: .navigation
        )
        .listStyle(.carousel)
    }
}
