//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_AppRunning: PreviewProvider {
    static let genericError = "Some generic error"

    static var previews: some View {

        Group {
            LuasView()
                .environmentObject(
                    AppState(
                        state: .gettingDueTimes(TrainStation(stationId: "stationId",
                                                             stationIdShort: "LUAS70",
                                                             shortCode: "CAB",
                                                             route: .green,
                                                             name: "Cabra",
                                                             locationBluebell: locationBluebell),
                                                locationBluebell)))
                .previewDisplayName("while getting info...")

            LuasView()
                .environmentObject(AppState(
                    state: .errorGettingDueTimes(stationRedLongName,
                                                 genericError)))
                .previewDisplayName("error getting due times (specific)")

            LuasView()
                .environmentObject(AppState(
                    state: .errorGettingDueTimes(stationGreen,
                                                 LuasStrings.errorGettingDueTimes)))
                .previewDisplayName("error getting due times (generic)")

            LuasView()
                .environmentObject(AppState(
                    state: .errorGettingDueTimes(stationGreen,
                                                 LuasStrings.errorNoInternet)))
                .previewDisplayName("error getting due times (offline)")
        }
    }
}
#endif
