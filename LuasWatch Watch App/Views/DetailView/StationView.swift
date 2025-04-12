//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

struct StationView {

  @EnvironmentObject private var appModel: AppModel
  @Environment(\.modelContext) private var modelContext

  @State private var direction: Direction = .both
}

extension StationView: View {

  var body: some View {

    makeStationView(for: appModel.appState)

      .toolbar {

        switch appModel.appState {

            // everything with LuasTextView has 'inactive' toolbar
          case .idle, .gettingLocation,
              .errorGettingLocation, .errorGettingStationTooFarAway, .errorGettingDueTimes:
            ToolbarInactive()

          case .locationAuthorizationUnknown:
            ToolbarInactive()

          case .loadingDueTimes(let station, _):
            StationToolbar(
              direction: $direction,
              trainStation: station
            )

          case .foundDueTimes(let trains):
            StationToolbar(
              direction: $direction,
              trainStation: trains.station
            )
        }
      }
  }

  @ViewBuilder
  fileprivate func makeStationView(for appState: AppState) -> some View {
    switch appState {

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

      case .errorGettingStationTooFarAway(let errorMessage):
        LuasTextView(text: errorMessage)
        
      case .loadingDueTimes(let trainStation, let cachedTrains):
        StationTimesView(
          direction: $direction,
          trainStation: trainStation,
          trains: cachedTrains
        )
        .onAppear {
          direction = modelContext.directionConsideringStationType(for: trainStation.shortCode)
        }

      case .errorGettingDueTimes(_, let message):
        LuasTextView(text: message)

      case .foundDueTimes(let trains):
        StationTimesView(
          direction: $direction,
          trainStation: trains.station,
          trains: trains
        )
        .onAppear {
          direction = modelContext.directionConsideringStationType(for: trains.station.shortCode)
        }
    }
  }

}
