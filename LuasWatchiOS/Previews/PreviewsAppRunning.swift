//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

#if DEBUG
  let genericError = "Some generic error"

  #Preview("while getting info") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .loadingDueTimes(
            TrainStation(
              stationIdShort: "LUAS70",
              shortCode: "CAB",
              route: .green,
              name: "Cabra",
              location: locationBluebell), cachedTrains: nil))
      )
  }

  #Preview("errGetDueTimes (spec)") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingDueTimes(stationRedLongName, genericError))
      )
  }

  #Preview("errGetDueTimes (gen)") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingDueTimes(
            stationGreen,
            LuasStrings.errorGettingDueTimes(station: stationGreen.name)))
      )
  }

  #Preview("errGetDueTimes (offline)") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingDueTimes(
            stationRedLongName, LuasStrings.errorNoInternet))
      )
  }
#endif
