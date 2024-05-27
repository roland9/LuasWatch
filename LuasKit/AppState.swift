//
//  Created by Roland Gropmair on 27/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

/// App's state machine, drives UI
public enum AppState {

    case idle

    case gettingLocation
    case locationAuthorizationUnknown
    case errorGettingLocation(String)

    /// in case the user is too far away from Dublin area
    case errorGettingStation(String)

    case loadingDueTimes(TrainStation, cachedTrains: TrainsByDirection?)
    case errorGettingDueTimes(TrainStation, String)

    case foundDueTimes(TrainsByDirection)

    public init(_ state: AppState) {
        self = state
    }
}

public extension AppState {
    
    var isLoading: Bool {
        if case .loadingDueTimes = self {
            return true
        } else {
            return false
        }
    }
}
