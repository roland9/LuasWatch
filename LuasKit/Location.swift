//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

public protocol LocationDelegate: class {
	func didFail(_ error: Error)
	func didGetLocation(_ location: CLLocation)
}

enum LocationState {
	case initializing, gettingLocation, stoppedUpdatingLocation, error
}

public class Location: NSObject {

	public weak var delegate: LocationDelegate?

	var state: LocationState = .initializing

	let locationManager = CLLocationManager()

	public override init() {}

	public func start() {

		// start getting location
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

		if CLLocationManager.locationServicesEnabled() {
			print("\(#function): services enabled")

			locationManager.requestWhenInUseAuthorization()
			locationManager.delegate = self

			state = .gettingLocation
			locationManager.startUpdatingLocation()

		} else {
			print("\(#function): services NOT enabled")

			state = .error
			// TODO error handling - expose message
			delegate?.didFail(NSError(domain: "ie.mapps.LuasWatch", code: 300, userInfo: nil))
		}
	}

	public func update() {
		if (state == .stoppedUpdatingLocation || state == .error) &&
			CLLocationManager.locationServicesEnabled() {

			locationManager.requestWhenInUseAuthorization()
			locationManager.delegate = self

			state = .gettingLocation
			locationManager.startUpdatingLocation()
		}
	}
}

extension Location: CLLocationManagerDelegate {

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("\(#function): \(error)")

		state = .error
		delegate?.didFail(error)
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("\(#function): \(locations)")

		let lastLocation = locations.last!

		// TODO If it's a relatively recent event, turn off updates to save power. Also, turn on again later

		let howRecent = lastLocation.timestamp.timeIntervalSinceNow

		if abs(howRecent) < 15.0 {
			// TODO we should kill previous API requests if there is a newer location
			delegate?.didGetLocation(lastLocation)

			if lastLocation.horizontalAccuracy < 100 &&
				lastLocation.verticalAccuracy < 100 {
				print("\(#function): last location quite precise, to stopping location updates for now")

				state = .stoppedUpdatingLocation
				locationManager.stopUpdatingLocation()
			}

		} else {
			print("\(#function): ignoring lastLocation because too old (\(howRecent) seconds ago")
		}

	}

}
