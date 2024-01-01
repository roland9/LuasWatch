//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct SidebarView: View {

    @State var selectedStation: TrainStation?

    let stations = TrainStations.sharedFromFile.greenLineStations

    var body: some View {
      List(selection: $selectedStation) {
            ForEach(stations, id: \.self) { station in
                NavigationLink(station.name,
                               value: station.name)
            }
        }
        .containerBackground(.green.gradient,
                             for: .navigation)
        .listStyle(.carousel)
    }
}

#Preview("Sidebar") {
    SidebarView()
}
