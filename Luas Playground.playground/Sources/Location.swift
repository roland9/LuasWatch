import CoreLocation

public class Location: NSObject {

	let locationManager = CLLocationManager()
	let appState: AppState

	public init(appState: AppState) {
		self.appState = appState
	}

	public func start() {

		// start getting location
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestAlwaysAuthorization()
			locationManager.delegate = self
		} else {

		}

		// once that succeeds, get station

		// once we have station, get departure times

	}
}

extension Location: CLLocationManagerDelegate {

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
		appState.state = .errorGettingLocation(error)
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations)
	}

}
