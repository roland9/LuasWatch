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
		case .gettingStation(_):
			return "getting station..."
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

public class AppState: Combine.ObservableObject {
	typealias PublisherType = PassthroughSubject<Void, Never>

	var didChange = PublisherType()

	var state: State {
		didSet {
			didChange.send(())
		}
	}

	init(state: State) {
		self.state = state
	}
}
