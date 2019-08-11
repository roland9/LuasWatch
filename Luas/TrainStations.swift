//
//  Created by Roland Gropmair on 07/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

typealias JSONDictionary = [String: Any]

struct TrainStation: CustomDebugStringConvertible {
	let stationId: String
	let name: String
	let location: CLLocation

	var debugDescription: String {
		return "\n<\(stationId)> \(name)  (\(location.coordinate.latitude)/\(location.coordinate.longitude))"
	}
}

struct TrainStations {
	let stations: [TrainStation]

	init(fromFile fileName: String) {
		guard
			let luasStopsFile = Bundle.main.url(forResource: "JSON/" + fileName, withExtension: "json"),
			let data = try? Data(contentsOf: luasStopsFile),
			let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
			let stationsArray = json["stations"] as? [JSONDictionary]
			else { fatalError("could not parse JSON file") }

		// swiftlint:disable force_cast
		stations = stationsArray.compactMap { (station) in
			return TrainStation(stationId: station["stationId"] as! String,
								name: station["name"] as! String,
								location: CLLocation(latitude: CLLocationDegrees(station["lat"] as! Double),
													 longitude: CLLocationDegrees(station["long"] as! Double)))
		}
		// swiftlint:enable force_cast
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
