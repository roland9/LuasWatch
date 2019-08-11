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
			locationManager.requestAlwaysAuthorization()
			locationManager.delegate = self

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

		delegate?.didGetLocation(locations.last!)
	}

}
