import Foundation
import CoreLocation

public enum State {
	case gettingLocation
	case errorGettingLocation(Error)

	case gettingStation(CLLocation)
	case errorGettingStation(Error)

	case gettingDepartureTimes(TrainStation)
	case errorGettingDepartureTimes(Error)

	case foundDepartureTimes(TrainsByDirection)
}
