//
//  Created by Roland Gropmair on 02/11/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct LuasMainScreen {

    @EnvironmentObject var appModel: AppModel
    @State var selectedTabView = 1
}

extension LuasMainScreen: View {

    var body: some View {

        NavigationSplitView {

            SidebarView(selectedStation: $appModel.selectedStation)
                .onAppear(perform: {
                    appModel.allowStationTabviewUpdates = false
                })

        } detail: {

            TabView(selection: $selectedTabView) {
                StationView()
                    .containerBackground(
                        appModel.selectedStation?.route.color.gradient ?? Color("luasTheme").gradient,
                        for: .navigation
                    )
                    .tag(1)

                StationsModal(
                    stations: appModel.selectedStation?.route == .green
                        ? TrainStations.sharedFromFile.greenLineStations : TrainStations.sharedFromFile.redLineStations,
                    highlightedStation: appModel.selectedStation,
                    action: { station in
                        appModel.appMode = .specific(station)
                        withAnimation {
                            selectedTabView = 1
                        }
                    }
                )
                .containerBackground(
                    appModel.selectedStation?.route.color.gradient ?? Color("luasTheme").gradient,
                    for: .navigation
                )
                .tag(2)

            }
            .tabViewStyle(.verticalPage)
            .onAppear {
                selectedTabView = 1
                appModel.allowStationTabviewUpdates = true
            }
            .onDisappear {
                appModel.allowStationTabviewUpdates = false
            }

        }
    }
}
