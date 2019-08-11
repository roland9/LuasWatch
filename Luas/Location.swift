//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

public protocol LocationDelegate: class {
	func didFail(_ error: Error)
	func didGetLocation(_ location: CLLocation)
}

public class Location: NSObject {

	public weak var delegate: LocationDelegate?

	let locationManager = CLLocationManager()

	public override init() {
	}

	public func start() {

		// start getting location
		if CLLocationManager.locationServicesEnabled() {
			print("\(#function): services enabled")
			locationManager.requestWhenInUseAuthorization()
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

			locationManager.startUpdatingLocation()

		} else {
			print("\(#function): services NOT enabled")

			// TODO error handling - expose message
			delegate?.didFail(NSError(domain: "ie.mapps.LuasWatch", code: 300, userInfo: nil))
		}
	}
}

extension Location: CLLocationManagerDelegate {

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("\(#function): \(error)")

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
		} else {
			print("\(#function): ignoring lastLocation because too old (\(howRecent) seconds ago")
		}

		if lastLocation.horizontalAccuracy < 100 &&
			lastLocation.verticalAccuracy < 100 {
			print("\(#function): last location quite precise, to stopping location updates for now")
			locationManager.stopUpdatingLocation()
		}
	}

}
