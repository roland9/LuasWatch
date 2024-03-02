//
//  Created by Roland Gropmair on 02/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationsModal: View {
    @EnvironmentObject var appModel: AppModel

    @State var stations: [TrainStation]
    var action: (TrainStation) -> Void
}

extension StationsModal {

    var body: some View {
        List {
            ForEach(stations, id: \.stationId) { (station) in

                // need a button here because just text only supports tap on the text but not full width
                Button(
                    action: {
                        action(station)
                    },
                    label: {
                        Text(station.name)
                            .font(.system(.headline))
                            .fontWeight(isHighlighted(for: station.name) ? .bold : .regular)
                    })
            }
        }
    }

    private func isHighlighted(for station: String) -> Bool {
        if case .specific(let specificStation) = appModel.appMode,
            specificStation.name == station
        {
            return true
        } else {
            return false
        }
    }
}

#Preview("Stations Modal (green)") {

    let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsGreen)))
    appModel.appMode = .specific(stationGreen)

    // highlight in preview doesn't work??  does it used StoredAppMode?
    return StationsModal(
        stations: TrainStations.sharedFromFile.greenLineStations,
        action: { _ in
            //
        }
    )
    .environmentObject(appModel)
}
