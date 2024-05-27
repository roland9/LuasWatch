//
//  Created by Roland Gropmair on 27/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

/// how user decided how current station should be determined
public enum AppMode: Equatable {

    /// need location
    case closest
    case closestOtherLine

    /// no location required, because user selected specific station (via various options)
    case favourite(TrainStation)
    case nearby(TrainStation)
    case specific(TrainStation)
    case recents(TrainStation)

    public var specificStation: TrainStation? {
        switch self {

            case .closest, .closestOtherLine:
                return nil
            case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                return station
        }
    }

    public var needsLocation: Bool {
        self == .closest || self == .closestOtherLine
    }
}
