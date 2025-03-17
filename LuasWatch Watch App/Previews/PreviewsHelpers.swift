//
//  Created by Roland Gropmair on 24/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

@MainActor
func makeTabView(
  _ appState: AppState,
  _ route: Route = .green
) -> some View {

  @State var selectedStation: TrainStation? = trainsGreen.station

  return NavigationSplitView {
    SidebarView(selectedStation: $selectedStation)
  } detail: {
    TabView(selection: $selectedStation) {
      StationView()
        .containerBackground(
          route.color.gradient,
          for: .tabView)
    }
  }
  .environmentObject(AppModel(appState))
  .modelContainer(Previews().container)
}

@MainActor
func luasMainScreen(state: AppState) -> some View {
  let appModel = AppModel(state)
  appModel.appMode = .favourite(stationGreen)

  return LuasMainScreen()
    .environmentObject(appModel)
    .modelContainer(Previews().container)
}

func makeAppModel(
  state: AppState,
  appMode: AppMode = .specific(stationGreen),
  locationDenied: Bool = false
) -> AppModel {
  let appModel = AppModel(state)
  appModel.appMode = appMode
  appModel.locationDenied = locationDenied

  return appModel
}

#endif
