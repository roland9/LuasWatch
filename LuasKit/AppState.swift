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
}

extension State: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {

		case .gettingLocation:
			return "getting location..."
		case .errorGettingLocation(let error):
			return "error getting location: \(error)"
		case .gettingStation(let location):
			return "getting station for location \(location.coordinate)..."
		case .errorGettingStation(let error):
			return "error getting station: \(error)"
		case .gettingDueTimes(let trainStation):
			return "getting due times for \(trainStation.name)..."
		case .errorGettingDueTimes(let errorMessage):
			return "error getting due times: \(errorMessage)"
		case .foundDueTimes(let trains):
			return "found due times: \(trains)"
		}
	}
}

public class AppState: ObservableObject {
	@Published public var state: State = .gettingLocation

	public init() {}
}
