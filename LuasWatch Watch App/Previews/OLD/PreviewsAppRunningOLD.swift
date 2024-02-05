////
////  Created by Roland Gropmair on 25/09/2021.
////  Copyright © 2021 mApps.ie. All rights reserved.
////
//
//import LuasKit
//import SwiftUI
//
//#if DEBUG
//    // swiftlint:disable:next type_name
//    struct Preview_AppRunning: PreviewProvider {
//        static let genericError = "Some generic error"
//
//        static var previews: some View {
//
//            Group {
//                LuasViewOLD()
//                    .environmentObject(
//                        AppState(
//                            state: .gettingDueTimes(
//                                TrainStation(
//                                    stationId: "stationId",
//                                    stationIdShort: "LUAS70",
//                                    shortCode: "CAB",
//                                    route: .green,
//                                    name: "Cabra",
//                                    locationBluebell: locationBluebell),
//                                locationBluebell))
//                    )
//                    .previewDisplayName("while getting info...")
//
//                LuasViewOLD()
//                    .environmentObject(
//                        AppState(
//                            state: .errorGettingDueTimes(
//                                stationRed,
//                                genericError))
//                    )
//                    .previewDisplayName("error getting due times (specific)")
//
//                LuasViewOLD()
//                    .environmentObject(
//                        AppState(
//                            state: .errorGettingDueTimes(
//                                stationGreen,
//                                LuasStrings.errorGettingDueTimes))
//                    )
//                    .previewDisplayName("error getting due times (generic)")
//
//                LuasViewOLD()
//                    .environmentObject(
//                        AppState(
//                            state: .errorGettingDueTimes(
//                                stationGreen,
//                                LuasStrings.errorNoInternet))
//                    )
//                    .previewDisplayName("error getting due times (offline)")
//            }
//        }
//    }
//#endif
