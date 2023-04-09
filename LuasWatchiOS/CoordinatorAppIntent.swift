//
//  Created by Roland Gropmair on 09/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

import LuasKitIOS

class CoordinatorAppIntent: NSObject {

    enum CoordinationError: Error {
        case stationNotFound(String)
    }

    func loadTrainTimes(for luasStop: String) async throws -> String {

        let station = TrainStations.sharedFromFile
            .stations
            .filter { $0.name == luasStop }
            .first

        guard let station else { throw CoordinationError.stationNotFound(luasStop) }

        let output = await station.loadTrainTimes()

        return output.shortcutOutput
    }
}

extension TrainStation {

    internal func loadTrainTimes() async -> MyState {

        await withCheckedContinuation { (continuation: CheckedContinuation<MyState, Never>) in

            LuasAPI2.dueTime(for: self) { (result) in

                switch result {
                    case .error(let error):
                        print("\(#function): \(error)")
                        continuation.resume(returning:
                                .errorGettingDueTimes(self,
                                                      error.count > 0 ? error : LuasStrings.errorGettingDueTimes))

                    case .success(let trains):
                        print("\(#function): \(trains)")
                        continuation.resume(returning:
                                .foundDueTimes(trains, location))
                }
            }
        }
    }
}
