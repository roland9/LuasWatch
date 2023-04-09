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

    @Parameter(title: "LUAS Stop", optionsProvider: LuasStopOptionsProvider())
    var luasStop: String

    private struct LuasStopOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            TrainStations.sharedFromFile
                .stations
                .map { $0.name }
                .sorted()
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue {

        let coordinator = CoordinatorAppIntent()

        let output = try await coordinator.loadTrainTimes(for: luasStop)

        return .result(value: output)
    }
}

extension MyState {

    var shortcutOutput: String {

        switch self {

            case .gettingLocation,
                    .errorGettingLocation,
                    .errorGettingStation,
                    .gettingDueTimes,
                    .errorGettingDueTimes,
                    .updatingDueTimes:
                return debugDescription

            case .foundDueTimes(let trains, _):
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

        return output.count > 0 ? output : "No trains found for \(trainStation.name) LUAS stop.\n"
    }
}
