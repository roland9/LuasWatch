//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

public protocol LocationDelegate: class {
	func didFail(_ error: LocationDelegateError)
	func didGetLocation(_ location: CLLocation)
}

public enum LocationDelegateError {
	case locationServicesNotEnabled
	case locationAccessDenied
	case locationManagerError(Error)
	case authStatusDenied
	case authStatus(CLAuthorizationStatus)
}

public class Location: NSObject {

	public weak var delegate: LocationDelegate?

	let locationManager = CLLocationManager()

	public override init() {}

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

			delegate?.didFail(.locationServicesNotEnabled)
		}
	}
}

extension Location: CLLocationManagerDelegate {

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("\(#function): \(error)")

		delegate?.didFail(.locationManagerError(error))
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("\(#function): \(locations)")

		let lastLocation = locations.last!

		// TODOLATER If it's a relatively recent event, turn off updates to save power. Also, turn on again later

		let howRecent = lastLocation.timestamp.timeIntervalSinceNow

		if abs(howRecent) < 15.0 {
			delegate?.didGetLocation(lastLocation)

			if lastLocation.horizontalAccuracy < 100 &&
				lastLocation.verticalAccuracy < 100 {
				print("\(#function): last location quite precise -> stopping location updates for now")
				locationManager.stopUpdatingLocation()
			}

		} else {
			print("\(#function): ignoring lastLocation because too old (\(howRecent) seconds ago")
		}

	}

}
