//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation
import CoreLocation

public enum Route: Int, Codable {
	case red, green
}

extension Route {
	init?(_ routeString: String) {
		if routeString == "Red" {
			self = .red
		} else if routeString == "Green" {
			self = .green
		} else {
			return nil
		}
	}
}

public struct Train: CustomDebugStringConvertible, Hashable, Codable {

	public var id: String {
		return direction + dueTime
	}

	public let destination: String
	public let direction: String
	public let dueTime: String

	public var debugDescription: String {
		return "\(destination.replacingOccurrences(of: "LUAS ", with: "")): \'\(dueTimeDescription)\'"
	}

	public var dueTimeDescription: String {
		return "\(destination.replacingOccurrences(of: "LUAS ", with: "")): " + (dueTime == "Due" ? "Due" : "\(dueTime) mins")
	}

	public init(destination: String, direction: String, dueTime: String) {
		self.destination = destination
		self.direction = direction
		self.dueTime = dueTime
	}
}

public struct TrainStation: CustomDebugStringConvertible {
	public let stationId: String		// not sure what that 'id' is for?
	public let stationIdShort: String 	// that is the 'id' required for the API
	public let route: Route
	public let name: String
	public let location: CLLocation
	public let isOneWay: Bool

	public var debugDescription: String {
		return "\n<\(stationIdShort)> \(name)  (\(location.coordinate.latitude)/\(location.coordinate.longitude))  isOneWay \(isOneWay)"
	}

	public init(stationId: String, stationIdShort: String, route: Route, name: String, location: CLLocation, isOneWay: Bool) {
		self.stationId = stationId
		self.stationIdShort = stationIdShort
		self.route = route
		self.name = name
		self.location = location
		self.isOneWay = isOneWay
	}
}

public struct TrainStations {

	public let stations: [TrainStation]

	public static let sharedFromFile = TrainStations.fromFile()

	private static func fromFile() -> TrainStations {
		return TrainStations.init(fromFile: "luasStops")
	}

	public init(fromFile fileName: String) {
		guard
			let luasStopsFile = Bundle.main.url(forResource: fileName, withExtension: "json"),
			let data = try? Data(contentsOf: luasStopsFile),
			let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
			let stationsArray = json["stations"] as? [JSONDictionary]
			else { fatalError("could not parse JSON file") }

		// swiftlint:disable force_cast
		stations = stationsArray.compactMap { (station) in
			return TrainStation(stationId: station["stationId"] as! String,
								stationIdShort: station["stationIdShort"] as! String,
								route: Route(station["route"] as! String)!,
								name: station["name"] as! String,
								location: CLLocation(latitude: CLLocationDegrees(station["lat"] as! Double),
													 longitude: CLLocationDegrees(station["long"] as! Double)),
								isOneWay: station["one_way"] as? Bool ?? false)
		}
		// swiftlint:enable force_cast
	}

	public init(stations: [TrainStation]) {
		self.stations = stations
	}

	public var redLineStations: [TrainStation] {
		return stations
			.filter { $0.route == .red }
	}

	public var greenLineStations: [TrainStation] {
		return stations
			.filter { $0.route == .green }
	}

	public func closestStation(from location: CLLocation) -> TrainStation? {
		var closestStationSoFar: TrainStation?

		stations.forEach { (station) in
			// don't consider stations if they're too far away, currently 20km
			if station.location.distance(from: location) > 20000 {
				return
			}

			if let closest = closestStationSoFar {
				if station.location.distance(from: location) < closest.location.distance(from: location) {
					closestStationSoFar = station
				}
			} else {
				closestStationSoFar = station
			}
		}

		return closestStationSoFar
	}
}

public struct TrainsByDirection {
	public let trainStation: TrainStation

	public let inbound: [Train]
	public let outbound: [Train]

	public init(trainStation: TrainStation,
				inbound: [Train],
				outbound: [Train]) {
		self.trainStation = trainStation
		self.inbound = inbound
		self.outbound = outbound
	}
}
