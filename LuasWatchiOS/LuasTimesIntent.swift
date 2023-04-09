//
//  Created by Roland Gropmair on 09/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation
import AppIntents
import CoreLocation

import LuasKitIOS

struct LuasTimesIntent: AppIntent {

    // TODO localize
    static var title: LocalizedStringResource = "Luas Times"

    static var description =
    IntentDescription("Determines user's location & shows the departure times of the closes LUAS stop.")

    func perform() async throws -> some IntentResult & ReturnsValue {

        let appState = AppState()
        let location = Location()

        let coordinator = CoordinatorAppIntent(appState: appState,
                                               location: location)

        let output = await coordinator.start()

        return .result(value: output)
    }
}

extension MyState {

    var shortcutOutput: String {

        switch self {

            case .gettingLocation,
                    .errorGettingLocation(_),
                    .errorGettingStation(_),
                    .gettingDueTimes(_, _),
                    .errorGettingDueTimes(_, _),
                    .updatingDueTimes(_, _):
                return debugDescription

            case .foundDueTimes(let trains, let location):
                return trains.shortcutOutput()
        }
    }
}


extension TrainsByDirection {

    func shortcutOutput() -> String {
        var output = ""

        // Cabra into City Centre only for now
//        output += inbound
//            .compactMap { "Luas to \($0.destination) in \($0.dueTime).\n" }
//            .joined()

        output += outbound
            .compactMap { "\($0.destination) in \($0.dueTime).\n" }
            .joined()

        return output.count > 0 ? output : "No Luas trains found for station \(trainStation).\n"
    }
}
