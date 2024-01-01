//
//  Created by Roland Gropmair on 02/11/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct MainResultView {

    @State var selectedStation: TrainStation?
}

extension MainResultView: View {

    var body: some View {

        NavigationSplitView {
            SidebarView(selectedStation: $selectedStation)

        } detail: {
            TabView(selection: $selectedStation) {
                    StationView(station: $selectedStation)
                        .tag(Optional(selectedStation))
                        .containerBackground(.blue.gradient,
                                             for: .tabView)
            }
        }
    }
}

#Preview("Main Result") {
    let stationGreen = TrainStation(stationId: "stationId",
                                    stationIdShort: "LUAS69",
                                    shortCode: "PHI",
                                    route: .green,
                                    name: "Phibsboro",
                                    location: location)

    return MainResultView(selectedStation: stationGreen)
        .modelContainer(Previews().container)
}
