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

	case gettingDepartureTimes(TrainStation)
	case errorGettingDepartureTimes(Error)

	case foundDepartureTimes(TrainsByDirection)
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
		case .gettingDepartureTimes(let trainStation):
			return "getting departure times for \(trainStation.name)..."
		case .errorGettingDepartureTimes(let error):
			return "error getting departure times: \(error)"
		case .foundDepartureTimes(let trains):
			return "found departure times: \(trains)"
		}
	}
}

public class AppState: ObservableObject {
	@Published var state: State = .gettingLocation
}
