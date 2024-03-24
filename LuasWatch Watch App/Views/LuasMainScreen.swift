//
//  Created by Roland Gropmair on 02/11/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct LuasMainScreen {

    @EnvironmentObject var appModel: AppModel
}

extension LuasMainScreen: View {

    var body: some View {

        NavigationSplitView {

            SidebarView(selectedStation: $appModel.selectedStation)
                .onAppear(perform: {
                    appModel.allowStationTabviewUpdates = false
                })

        } detail: {

            StationView()
                .containerBackground(
                    appModel.selectedStation?.route.color.gradient ?? Color("luasTheme").gradient,
                    for: .navigation
                )

                .onAppear(perform: {
                    appModel.allowStationTabviewUpdates = true
                })

                .onDisappear(perform: {
                    appModel.allowStationTabviewUpdates = false
                })

        }
    }
}
