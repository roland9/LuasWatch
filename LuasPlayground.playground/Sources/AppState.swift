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

	case gettingDueTimes(TrainStation)
	case errorGettingDueTimes(String)

	case foundDueTimes(TrainsByDirection)

	case updatingDueTimes(TrainsByDirection)
}

extension MyState: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {

			case .gettingLocation:
				return LuasStrings.gettingLocation

			case .errorGettingLocation(let errorMessage):
				return errorMessage

			case .errorGettingStation:
				return LuasStrings.errorGettingStation

			case .gettingDueTimes(let trainStation):
				return LuasStrings.gettingDueTimes(trainStation)

			case .errorGettingDueTimes(let errorMessage):
				return errorMessage

			case .foundDueTimes(let trains):
				return LuasStrings.foundDueTimes(trains)

			case .updatingDueTimes(let trains):
				return LuasStrings.updatingDueTimes(trains)
		}
	}
}

public class AppState: ObservableObject {
	@Published public var state: MyState = .gettingLocation

	public init() {}

	public init(state: MyState) {
		self.state = state
	}
}
