//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import Combine

public enum State {
	case gettingLocation
	case errorGettingLocation(Error)

	case errorGettingStation(Error)		// in case the user is too far away

	case gettingDueTimes(TrainStation)
	case errorGettingDueTimes(String)

	case foundDueTimes(TrainsByDirection)

	case updatingDueTimes(TrainsByDirection)
}

extension State: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {

		case .gettingLocation:
			return NSLocalizedString("Getting your location...", comment: "")
		case .errorGettingLocation(let error):
			if (error as NSError).code == CLError.denied.rawValue {
				// if user denied location access for entire app
				return NSLocalizedString("Error getting your location: location access denied", comment: "")
			} else {
				// if didChangeAuthorization comes through
				// TODO check code / userInfo
				return NSLocalizedString("Error getting your location: \(error.localizedDescription)", comment: "")
			}
		case .errorGettingStation:
			return NSLocalizedString("Error finding station.\n\nPlease try again later.", comment: "")
		case .gettingDueTimes(let trainStation):
			return NSLocalizedString("Getting due times for \(trainStation.name)...", comment: "")
		case .errorGettingDueTimes(let errorMessage):
			return errorMessage
		case .foundDueTimes(let trains):
			return NSLocalizedString("Found due times: \(trains)", comment: "")
		case .updatingDueTimes(let trains):
			return NSLocalizedString("Updating due times (current trains: \(trains))", comment: "")
		}
	}
}

public class AppState: ObservableObject {
	@Published public var state: State = .gettingLocation

	public init() {}

	public init(state: State) {
		self.state = state
	}
}
