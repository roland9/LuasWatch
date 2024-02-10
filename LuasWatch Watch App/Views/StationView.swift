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

            case .errorGettingLocation(_):
                // Note: we do get error description as well, but we ignore it in UI
                LuasTextView(text: appModel.appState.description)

            case .errorGettingStation(let errorMessage):
                LuasTextView(text: errorMessage)

            case .loadingDueTimes(_):
                // Note: we do get location here in this enum as well, but we ignore it in the UI
                LuasTextView(text: appModel.appState.description)

            case .errorGettingDueTimes(_, _):
                // this enum has second parameter 'errorString', but it's not shown here
                // because it's surfaced via the appState's `description`
                LuasTextView(text: appModel.appState.description)

            case .foundDueTimes(let trains),
                .updatingDueTimes(let trains):
                StationTimesView(trains: trains)
        }
    }
}
