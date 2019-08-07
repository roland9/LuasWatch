//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
	let allStations: TrainStations
	let logs = Logs(["one", "two"])

	init(allStations: TrainStations) {
		self.allStations = allStations
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations)
		logs.logEntries.append(locations.description)
//		print(allStations.closestStation(from: userLocation))
	}
}

class Location: NSObject {

	let locationManager = CLLocationManager()
	let locationDelegate = LocationDelegate(allStations: TrainStations(fromFile: "luasStops"))
	
	override init() {
		locationManager.requestAlwaysAuthorization()

		locationManager.delegate = locationDelegate
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

		locationManager.startUpdatingLocation()
	}
}
