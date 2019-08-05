//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
	let allStations: Location.TrainStations

	init(allStations: Location.TrainStations) {
		self.allStations = allStations
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations)

//		print(allStations.closestStation(from: userLocation))
	}
}

class Location: NSObject {

	let locationManager = CLLocationManager()
	let locationDelegate = LocationDelegate(allStations: TrainStations(fromFile: "luasStops"))

	struct TrainStation: CustomDebugStringConvertible {
		let stationId: String
		let name: String
		let location: CLLocation

		var debugDescription: String {
			return "\n<\(stationId)> \(name)  (\(location.coordinate.latitude)/\(location.coordinate.longitude))"
		}
	}

	typealias JSONDictionary = [String: Any]

	struct TrainStations {
		let stations: [TrainStation]

		init(fromFile fileName: String) {
			guard
				let luasStopsFile = Bundle.main.url(forResource: fileName, withExtension: "json"),
				let data = try? Data(contentsOf: luasStopsFile),
				let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
				let stationsArray = json["stations"] as? [JSONDictionary]
				else { fatalError("could not parse JSON file") }

			stations = stationsArray.compactMap { (station) in
				return TrainStation(stationId: station["stationId"] as! String,
									name: station["name"] as! String,
									location: CLLocation(latitude: CLLocationDegrees(station["lat"] as! Double),
														 longitude: CLLocationDegrees(station["long"] as! Double)))
			}
		}

		func closestStation(from location: CLLocation) -> TrainStation {
			var closestStationSoFar: TrainStation?

			stations.forEach { (station) in
				if let closest = closestStationSoFar {
					if station.location.distance(from: location) < closest.location.distance(from: location) {
						closestStationSoFar = station
					}
				} else {
					closestStationSoFar = station
				}
			}

			return closestStationSoFar!
		}
	}

	override init() {
		locationManager.requestAlwaysAuthorization()

		locationManager.delegate = locationDelegate
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

		locationManager.startUpdatingLocation()
	}
}
