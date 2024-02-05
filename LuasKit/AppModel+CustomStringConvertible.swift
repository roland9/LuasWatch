//
//  Created by Roland Gropmair on 05/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

extension AppModel.AppState: CustomStringConvertible {

    public var description: String {
        switch self {

            case .idle:
                return "Idle"
            case .gettingLocation:
                return LuasStrings.gettingLocation
            case .locationAuthorizationUnknown:
                return LuasStrings.locationAuthorizationUnknown
            case .errorGettingLocation(let errorMessage):
                return errorMessage
            case .errorGettingStation:
                return LuasStrings.errorGettingStation
            case .loadingDueTimes(let trainStation):
                return LuasStrings.gettingDueTimes(trainStation)
            case .errorGettingDueTimes(_, let errorMessage):
                return errorMessage
            case .foundDueTimes(let trains):
                return LuasStrings.foundDueTimes(trains)
            case .updatingDueTimes(let trains):
                return LuasStrings.updatingDueTimes(trains)
        }
    }
}

extension AppModel.AppMode: CustomStringConvertible {

    public var description: String {
        switch self {
            case .closest:
                return "closest"
            case .closestOtherLine:
                return "closestOtherLine"
            case .favourite(let station):
                return "favourite: \(station.name)"
            case .nearby(let station):
                return "nearby \(station.name)"
            case .specific(let station):
                return "specific: \(station.name)"
            case .recents(let station):
                return "recents: \(station.name)"
        }
    }
}
