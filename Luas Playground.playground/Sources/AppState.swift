//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import Combine

public enum State {
	case gettingLocation
	case errorGettingLocation(Error)

	case gettingStation(CLLocation)
	case errorGettingStation(Error)

	case gettingDueTimes(TrainStation)
	case errorGettingDueTimes(String)

	case foundDueTimes(TrainsByDirection)

	case updatingDueTimes(TrainsByDirection)
}

extension State: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {

		case .gettingLocation:
			return "Getting your location..."
		case .errorGettingLocation(let error):
			return "Error getting location: \(error)"
		case .gettingStation:
			return "Finding closest station..."
		case .errorGettingStation(let error):
			return "Error finding station: \(error)"
		case .gettingDueTimes(let trainStation):
			return "Getting due times for \(trainStation.name)..."
		case .errorGettingDueTimes(let errorMessage):
			return "Error getting due times: \(errorMessage)"
		case .foundDueTimes(let trains):
			return "Found due times: \(trains)"
		case .updatingDueTimes(let trains):
			return "Updating due times (current trains: \(trains))"
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
