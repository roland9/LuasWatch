//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
    private func luasView(state: AppModel.AppState) -> some View {
        let appModel = AppModel(state)
        appModel.appMode = .favourite(stationGreen)

        return LuasMainScreen()
            .environmentObject(appModel)
            .modelContainer(Previews().container)
    }

    #Preview("idle") {
        luasView(state: .idle)
    }

    #Preview("gettingLoc") {
        luasView(state: .gettingLocation)
    }

    #Preview("authUnk") {
        luasView(state: .locationAuthorizationUnknown)
    }

    #Preview("locErr") {
        luasView(state: .errorGettingLocation("Error getting location."))
    }

    #Preview("errStat") {
        luasView(state: .errorGettingStation("Some internal error getting station."))
    }

    #Preview("errLoading") {
        luasView(state: .errorGettingDueTimes(stationGreen, "Error loading due times - could not access internet?"))
    }
#endif
