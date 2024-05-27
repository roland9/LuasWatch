//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationView {

    @EnvironmentObject private var appModel: AppModel
}

extension StationView: View {

    var body: some View {

        switch appModel.appState {

            case .idle:
                LuasTextView(text: "LuasWatch is starting...")

            case .gettingLocation:
                LuasTextView(text: "Getting location...")

            case .locationAuthorizationUnknown:
                // WIP we need new approach to trigger location prompt via appModel?
                GrantLocationAuthView(didTapButton: {
                    appModel.appState = .gettingLocation
                })

            case .errorGettingLocation:
                LuasTextView(text: appModel.appState.description)

            case .errorGettingStation(let errorMessage):
                LuasTextView(text: errorMessage)

            case .loadingDueTimes(let trainStation, let cachedTrains):
                if let cachedTrains {
                    StationTimesView(trains: cachedTrains, isLoading: true)
                } else {
                    // no cachedTrains: we're loading that station for the first time
                    StationTimesViewLoadingFirstTime(trainStation: trainStation)
                }

            case .errorGettingDueTimes(_, let message):
                LuasTextView(text: message)

            case .foundDueTimes(let trains):
                StationTimesView(trains: trains)
        }
    }
}
