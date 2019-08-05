//
//  Location.swift
//  Luas
//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import UIKit

class LocationDelegate: NSObject, CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations)
	}
}

class Location: NSObject {

	let locationManager = CLLocationManager()
	let locationDelegate = LocationDelegate()

	override init() {
		print(CLLocationManager.locationServicesEnabled())

		locationManager.requestAlwaysAuthorization()

		locationManager.delegate = locationDelegate
		//locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

		locationManager.startUpdatingLocation()
	}
}
