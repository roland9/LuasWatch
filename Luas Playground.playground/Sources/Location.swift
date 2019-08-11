import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations)
	}
}
