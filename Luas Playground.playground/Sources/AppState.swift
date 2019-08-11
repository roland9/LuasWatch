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