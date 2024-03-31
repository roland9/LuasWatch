//
//  Created by Roland Gropmair on 31/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
    #Preview("Sidebar") {
        @State var selectedStation: TrainStation?

        let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation)))
        appModel.appMode = .favourite(stationGreen)

        return SidebarView(selectedStation: $selectedStation)
            .environmentObject(appModel)
            .modelContainer(Previews().container)
    }

    #Preview("Sidebar (loc denied)") {
        @State var selectedStation: TrainStation?

        let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation)))
        appModel.appMode = .favourite(stationGreen)
        appModel.locationDenied = true

        return SidebarView(selectedStation: $selectedStation)
            .environmentObject(appModel)
            .modelContainer(Previews().container)
    }

    #Preview("Sidebar (far away)") {
        @State var selectedStation: TrainStation?

        let appModel = AppModel(AppModel.AppState(.errorGettingStationTooFarAway(LuasStrings.tooFarAway)))
        appModel.appMode = .closest

        return SidebarView(selectedStation: $selectedStation)
            .environmentObject(appModel)
            .modelContainer(Previews().container)
    }
#endif
