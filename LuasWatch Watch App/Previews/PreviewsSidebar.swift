//
//  Created by Roland Gropmair on 31/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG

#Preview("normal") {
  @Previewable @State var selectedStation: TrainStation?
  let appModel = makeAppModel(
    state: AppState(.foundDueTimes(trainsOneWayStation)),
    appMode: .favourite(stationGreen))
  
  SidebarView(selectedStation: $selectedStation)
    .environmentObject(appModel)
    .modelContainer(Previews().container)
}

#Preview("err far away") {
  @Previewable @State var selectedStation: TrainStation?
  let appModel = makeAppModel(
    state: AppState(
      .errorGettingStationTooFarAway(LuasStrings.tooFarAway)),
    appMode: .closest)
  
  SidebarView(selectedStation: $selectedStation)
    .environmentObject(appModel)
    .modelContainer(Previews().container)
}

#Preview("loc denied") {
  @Previewable @State var selectedStation: TrainStation?
  
  let appModel = makeAppModel(
    state: AppState(.foundDueTimes(trainsOneWayStation)),
    appMode: .favourite(stationGreen), locationDenied: true)
  
  SidebarView(selectedStation: $selectedStation)
    .environmentObject(appModel)
    .modelContainer(Previews().container)
}
#endif
