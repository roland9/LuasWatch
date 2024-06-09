//
//  Created by Roland Gropmair on 09/06/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit

extension TrainStation {

    internal func loadFromAPIAndFormat(direction: DirectionEnum) async -> String {

        do {
            let api = LuasAPI(apiWorker: RealAPIWorker())

            let trains = try await api.dueTimes(for: self)

            return trains.formatForShortcut(direction: direction.toLuasKitDirection)

        } catch {

            if let apiError = error as? APIError {

                //  TODO need to test this - does it say cryptic error message!
                switch apiError {
                    case .noTrains(let message):
                        return message

                    case .invalidXML:
                        return "Error reading server response"
                }
            } else {
                return "Error reading server response"
            }
        }
    }
}
