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
      StationTimesView(trainStation: trainStation, trains: cachedTrains)

    case .errorGettingDueTimes(_, let message):
      LuasTextView(text: message)

    case .foundDueTimes(let trains):
      StationTimesView(trainStation: trains.trainStation, trains: trains)
    }
  }
}
