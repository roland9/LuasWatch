//
//  Created by Roland Gropmair on 10/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import AppIntents
import CoreLocation

import LuasKitIOS

struct LuasWatchAppIntent: AppIntent {

    static var title: LocalizedStringResource = "Luas Times"

    static var description =
    IntentDescription("Shows departure times of a specific LUAS stop.")

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
        let output = try await loadTrainTimes(for: luasStop)

        return .result(value: output)
    }

    enum CoordinationError: Error {
        case stationNotFound(String)
    }

    func loadTrainTimes(for luasStop: String) async throws -> String {

        let station = TrainStations.sharedFromFile
            .stations
            .filter { $0.name == luasStop }
            .first

        guard let station else { throw CoordinationError.stationNotFound(luasStop) }

        return await station.loadTrainTimesFromAPI()
    }
}

extension TrainStation {

    internal func loadTrainTimesFromAPI() async -> String {

        await withCheckedContinuation { (continuation: CheckedContinuation<String, Never>) in

            LuasAPI2.dueTime(for: self) { (result) in

                switch result {
                    case .error(let error):
                        print("\(#function): \(error)")
                        continuation.resume(returning: error.count > 0 ? error :
                                                LuasStrings.errorGettingDueTimes)

                    case .success(let trains):
                        print("\(#function): \(trains)")
                        continuation.resume(returning: trains.shortcutOutput())
                }
            }
        }
    }
}
