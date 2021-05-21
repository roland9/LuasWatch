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
	case authStatus(CLAuthorizationStatus)
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
			delegate?.didFail(.locationServicesNotEnabled)
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
		let nsError = error as NSError

		if nsError.domain == kCLErrorDomain &&
			nsError.code == CLError.Code.denied.rawValue {
			delegate?.didFail(.locationAccessDenied)
		} else if nsError.domain == kCLErrorDomain &&
					nsError.code == CLError.Code.locationUnknown.rawValue {
		} else {
			delegate?.didFail(.locationManagerError(error))
		}
	}

	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("\(CLLocationManager.authorizationStatus())")

		let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()

		switch authorizationStatus {
			case .denied, .notDetermined, .restricted:
				delegate?.didFail(.authStatus(authorizationStatus))
			case .authorizedAlways:
				print("authorizedAlways")
			case .authorizedWhenInUse:
				print("authorizedWhenInUse")
			@unknown default:
				print("default")
		}
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("\(#function): \(locations)")

		let lastLocation = locations.last!

		// TODOLATER If it's a relatively recent event, turn off updates to save power. Also, turn on again later

		let howRecent = lastLocation.timestamp.timeIntervalSinceNow

		if abs(howRecent) < 15.0 {
			// TODO we should kill previous API requests if there is a newer location
			delegate?.didGetLocation(lastLocation)

			if lastLocation.horizontalAccuracy < 100 &&
				lastLocation.verticalAccuracy < 100 {
				print("\(#function): last location quite precise -> stopping location updates for now")

				state = .stoppedUpdatingLocation
				locationManager.stopUpdatingLocation()
			}

		} else {
			print("\(#function): ignoring lastLocation because too old (\(howRecent) seconds ago")
		}

	}

}
