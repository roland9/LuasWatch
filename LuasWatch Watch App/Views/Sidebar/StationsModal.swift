//
//  Created by Roland Gropmair on 02/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationsModal: View {

  var stations: [TrainStation]
  var highlightedStation: TrainStation?

  var action: (TrainStation) -> Void
}

extension StationsModal {

  var body: some View {
    ScrollViewReader { (reader) in
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
                .fontWeight(highlightedStation?.name == station.name ? .bold : .regular)
            }
          )
          .id(station.shortCode)
        }
      }
      .onAppear {
        // if we have a highlightedStation, scroll to it (will show up near bottom of screen)
        guard let highlightedStation else {
          return
        }
        reader.scrollTo(highlightedStation.shortCode)
      }
    }
  }
}

#if DEBUG
  #Preview("Stations Modal (green)") {

    let appModel = AppModel(AppState(.foundDueTimes(trainsGreen)))
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
#endif
