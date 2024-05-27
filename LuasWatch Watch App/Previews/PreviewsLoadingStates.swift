//
//  Created by Roland Gropmair on 14/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
    private func luasView(state: AppState) -> some View {
        let appModel = AppModel(state)
        appModel.appMode = .favourite(stationGreen)

        return LuasMainScreen()
            .environmentObject(appModel)
            .modelContainer(Previews().container)
    }

    // new: should show other elements / frame now
    #Preview("loading") {
        luasView(state: .loadingDueTimes(stationGreen, nil))
    }

    #Preview("loading (cached)") {
        luasView(state: .loadingDueTimes(stationGreen, trainsGreen))
    }

    #Preview("loading 1Way (cached)") {
        luasView(state: .loadingDueTimes(stationOneWay, trainsMarlborough))
    }

    #Preview("noTrains") {
        luasView(state: .foundDueTimes(noTrainsGreen))
    }

    #Preview("OK") {
        luasView(state: .foundDueTimes(trainsGreen))
    }
#endif
