//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct StationView: View {

    @Binding var station: TrainStation?

    var body: some View {
        guard let station else {
            return Text("Unknown")
        }

        return Text("\(station.name)")
    }
}

#Preview("Station View") {
    @State var station: TrainStation? =
    TrainStation(stationId: "stationId",
                 stationIdShort: "LUAS69",
                 shortCode: "PHI",
                 route: .green,
                 name: "Phibsboro",
                 location: location)

    return StationView(station: $station)
}
