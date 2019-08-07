import CoreLocation
import PlaygroundSupport
import UIKit
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

let allStations = TrainStations(fromFile: "luasStops")
let userLocation = CLLocation(latitude: CLLocationDegrees(53.3163934083453), longitude: CLLocationDegrees(-6.25344151996991))

print(allStations.closestStation(from: userLocation))

print("Hello World")
