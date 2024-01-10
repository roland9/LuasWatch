//
//  Created by Roland Gropmair on 02/11/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct LuasView2 {

    @EnvironmentObject var appModel: AppModel
}

extension LuasView2: View {

    var body: some View {

        NavigationSplitView {
            SidebarView(selectedStation: $appModel.selectedStation)

        } detail: {
            TabView(selection: $appModel.selectedStation) {
                    StationView(station: $appModel.selectedStation)
                        .tag(Optional(appModel.selectedStation))
                        .containerBackground(appModel.selectedStation?.route.color.gradient ?? Color("luasTheme").gradient,
                                             for: .tabView)
            }
        }
    }
}

#Preview("Phibs") {
    let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation, userLocation)))
    appModel.selectedStation = stationGreen
    
    return LuasView2()
        .environmentObject(appModel)
}
