//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import Combine

public enum MyState {
    
	case gettingLocation
	case errorGettingLocation(String)

	case errorGettingStation(String)		// in case the user is too far away

	case gettingDueTimes(TrainStation, CLLocation)
	case errorGettingDueTimes(TrainStation, String)

	case foundDueTimes(TrainsByDirection, CLLocation)

	case updatingDueTimes(TrainsByDirection, CLLocation)
}

extension MyState: CustomStringConvertible {

	public var description: String {
		switch self {

		case .gettingLocation:
			return LuasStrings.gettingLocation

		case .errorGettingLocation(let errorMessage):
			return errorMessage

		case .errorGettingStation:
			return LuasStrings.errorGettingStation

		case .gettingDueTimes(let trainStation, _):
			return LuasStrings.gettingDueTimes(trainStation)

		case .errorGettingDueTimes(_, let errorMessage):
			return errorMessage

		case .foundDueTimes(let trains, _):
			return LuasStrings.foundDueTimes(trains)

		case .updatingDueTimes(let trains, _):
			return LuasStrings.updatingDueTimes(trains)
		}
	}
}

public class AppState: ObservableObject {
	@Published public var state: MyState = .gettingLocation
	@Published public var isStationsModalPresented: Bool = false

	public init() {}

	public init(state: MyState) {
		self.state = state
	}
}
