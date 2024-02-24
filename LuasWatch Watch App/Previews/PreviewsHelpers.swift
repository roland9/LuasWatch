//
//  Created by Roland Gropmair on 24/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
    func makeTabView(_ appModel: AppModel, _ route: Route) -> some View {

        @State var selectedStation: TrainStation? = trainsGreen.trainStation

        return NavigationSplitView {
            SidebarView(selectedStation: $selectedStation)
        } detail: {
            TabView(selection: $selectedStation) {
                StationView()
                    .environmentObject(appModel)
                    .modelContainer(Previews().container)
                    .containerBackground(
                        route.color.gradient,
                        for: .tabView)
            }
        }
    }
#endif
