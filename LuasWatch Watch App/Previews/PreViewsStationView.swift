//
//  Created by Roland Gropmair on 21/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#Preview("Phibs (not fav)") {
    let trains = trainsGreen

    let appModel = AppModel(.foundDueTimes(trains, userLocation))

    return TabView {
        StationView()
            .environmentObject(appModel)
            .modelContainer(Previews().container)
            .containerBackground(
                trains.trainStation.route.color.gradient,
                for: .tabView)
    }
}

#Preview("Tallaght (fav)") {
    let trains = trainsFinalStop

    let appModel = AppModel(.foundDueTimes(trains, userLocation))

    return TabView {
        StationView()
            .environmentObject(appModel)
            .modelContainer(Previews().container)
            .containerBackground(
                trains.trainStation.route.color.gradient,
                for: .tabView)
    }
}
