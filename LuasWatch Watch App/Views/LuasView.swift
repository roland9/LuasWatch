//
//  Created by Roland Gropmair on 02/11/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct LuasView {

    @EnvironmentObject var appModel: AppModel
}

extension LuasView: View {

    var body: some View {

        NavigationSplitView {

            SidebarView(selectedStation: $appModel.selectedStation)
                .onAppear(perform: {
                    appModel.allowStationTabviewUpdates = false
                })

        } detail: {
            TabView(selection: $appModel.selectedStation) {
                StationView()
                    .tag(Optional(appModel.selectedStation))
                    .containerBackground(
                        appModel.selectedStation?.route.color.gradient ?? Color("luasTheme").gradient,
                        for: .tabView)
            }
            .onAppear(perform: {
                appModel.allowStationTabviewUpdates = true
            })
            .onDisappear(perform: {
                appModel.allowStationTabviewUpdates = false
            })

        }
    }
}
