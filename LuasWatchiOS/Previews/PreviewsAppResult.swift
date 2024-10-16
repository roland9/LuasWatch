//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG
  // swiftlint:disable:next type_name
  struct Preview_AppResult: PreviewProvider {
    static var previews: some View {

      Group {
        //			LuasView()
        //				.environmentObject(AppState(state: .foundDueTimes(trainsRed_1_1, userLocation)))
        //				.previewDisplayName("found due times - 1:1")
        //
        //			LuasView()
        //				.environmentObject(AppState(state: .foundDueTimes(trainsRed_1_1, location)))
        //				.previewDisplayName("found due times - user very close")
        //
        //			LuasView()
        //				.environmentObject(AppState(state: .foundDueTimes(trainsRed_2_1, userLocation)))
        //				.previewDisplayName("found due times - 2:1")
        //
        //			LuasView()
        //				.environmentObject(AppState(state: .foundDueTimes(trainsRed_3_2, userLocation)))
        //				.previewDisplayName("found due times - 3:2")
        //
        //			LuasView().previewDevice("Apple Watch Series 3 - 38mm")
        //				.environmentObject(AppState(state: .foundDueTimes(trainsRed_4_4, userLocation)))
        //				.previewDisplayName("Small watch - found due times - 4:4")
        //
        //			LuasView()
        //				.environmentObject(AppState(state: .updatingDueTimes(trainsGreen, userLocation)))
        //				.previewDisplayName("updating due times")
        //
        //			LuasView()
        //				.environmentObject(
        //					AppState(
        //						state: .errorGettingDueTimes(stationGreen,
        //													 "No service Broombridge-Parnell. See news.")))
        //				.previewDisplayName("error getting due times - with real message from API")
        //			LuasView()
        //				.environmentObject(
        //					AppState(
        //						state: .errorGettingDueTimes(stationGreen,
        //													 LuasStrings.noTrainsErrorMessage + "\n\n" +
        //													 LuasStrings.noTrainsFallbackExplanation)))
        //				.previewDisplayName("error getting due times - with fallback text")
      }

      // there is a limit of 10  views we can pack into a group!
      Group {
        LuasView()
          .environmentObject(
            AppState(
              state: .errorGettingDueTimes(
                stationGreen,
                LuasStrings.noTrainsErrorMessage + "\n\n" + LuasStrings.noTrainsFallbackExplanation)
            )
          )
          .environment(\.sizeCategory, .extraExtraLarge)
          .previewDisplayName("error getting due times (larger) - not working??")

        LuasView()
          .environmentObject(AppState(state: .foundDueTimes(trainsOneWayStation, userLocation)))
          .previewDisplayName("found due times - one way stop")

        LuasView()
          .environmentObject(AppState(state: .foundDueTimes(trainsFinalStop, userLocation)))
          .previewDisplayName("found due times - final stop")
      }
    }
  }
#endif
