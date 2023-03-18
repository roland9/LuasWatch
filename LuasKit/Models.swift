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

	public var other: Route {
		switch self {
			case .red:
				return .green
			case .green:
				return .red
		}
	}
}

public struct Train: CustomDebugStringConvertible, Hashable, Codable {

	public var id: String {
		direction + dueTime
	}

	public let destination: String
	public let direction: String
	public let dueTime: String

	public var debugDescription: String {
		"\(destination.replacingOccurrences(of: "LUAS ", with: "")): \'\(dueTimeDescription)\'"
	}

	public var dueTimeDescription: String {
		"\(destination.replacingOccurrences(of: "LUAS ", with: "")): " +
			((dueTime == "Due" || dueTime == "DUE") ? "Due" : "\(dueTime) mins")
	}

	public init(destination: String, direction: String, dueTime: String) {
		self.destination = destination
		self.direction = direction
		self.dueTime = dueTime
	}
}

public struct TrainStation: CustomDebugStringConvertible, Identifiable {

	public enum StationType: String {
		case twoway, oneway, terminal
	}

    public let id: String
	public let stationId: String		// not sure what that 'id' is for?
	public let stationIdShort: String 	// that is the 'id' required for the API
	public let shortCode: String		// three-letter code, such as 'RAN'; for the XML API
	public let route: Route
	public let name: String
	public let location: CLLocation
	public let stationType: StationType

	public var debugDescription: String {
		return "\n<\(stationIdShort)> \(name)  (\(location.coordinate.latitude)/\(location.coordinate.longitude))  type \(stationType)"
	}

	public init(stationId: String, stationIdShort: String, shortCode: String,
				route: Route, name: String,
				location: CLLocation, stationType: StationType = .twoway) {
        self.id = stationId
		self.stationId = stationId
		self.stationIdShort = stationIdShort
		self.shortCode = shortCode
		self.route = route
		self.name = name
		self.location = location
		self.stationType = stationType
	}

	public var isFinalStop: Bool {
		.terminal == stationType
	}

	public var isOneWayStop: Bool {
		.oneway == stationType
	}

	public var allowsSwitchingDirection: Bool {
		.twoway == stationType
	}

	// will return nil if the distance is quite small, i.e. if the user is quite close to the station
	public func distance(from userLocation: CLLocation) -> String? {
		let minimumDistance = Measurement<UnitLength>(value: 200, unit: .meters)
		let distance = Measurement<UnitLength>(value: location.distance(from: userLocation),
											unit: .meters)

		guard distance > minimumDistance else { return nil }

		return Self.distanceFormatter.string(from: distance)
	}

	private static let distanceFormatter: MeasurementFormatter = {
		let formatter = MeasurementFormatter()
		formatter.locale = Locale(identifier: "en_IE")	// not correct we hard coded the locale here!
		formatter.unitOptions = .naturalScale
		formatter.unitStyle = .medium
		formatter.numberFormatter.usesSignificantDigits = true
		formatter.numberFormatter.maximumSignificantDigits = 1

		return formatter
	}()
}

public struct TrainStations {

	public let stations: [TrainStation]

	public static let sharedFromFile = TrainStations.fromFile()
    public static let cityCentre: TrainStation = TrainStations
        .fromFile()
        .stations
        .filter { $0.name == "O'Connell - GPO" }
        .first!

	private static func fromFile() -> TrainStations {
		TrainStations(fromFile: "luasStops")
	}

	private init(fromFile fileName: String) {
		guard
			let luasStopsFile = Bundle.main.url(forResource: "JSON/" + fileName, withExtension: "json"),
			let data = try? Data(contentsOf: luasStopsFile),
			let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
			let stationsArray = json["stations"] as? [JSONDictionary]
			else { fatalError("could not parse JSON file") }

		// swiftlint:disable force_cast
		stations = stationsArray.compactMap { (station) in

			var stationTypeValue: TrainStation.StationType = .twoway

			if let stationTypeString = station["type"] as? String,
				let stationType = TrainStation.StationType(rawValue: stationTypeString) {
				stationTypeValue = stationType
			}

			return TrainStation(stationId: station["stationId"] as! String,
								stationIdShort: station["stationIdShort"] as! String,
								shortCode: station["shortCode"] as! String,
								route: Route(station["route"] as! String)!,
								name: station["name"] as! String,
								location: CLLocation(latitude: CLLocationDegrees(station["lat"] as! Double),
													 longitude: CLLocationDegrees(station["long"] as! Double)),
								stationType: stationTypeValue)
		}
		// swiftlint:enable force_cast
	}

	public init(stations: [TrainStation]) {
		self.stations = stations
	}

	public var redLineStations: [TrainStation] {
		stations
			.filter { $0.route == .red }
	}

	public var greenLineStations: [TrainStation] {
		stations
			.filter { $0.route == .green }
	}

	public func closestStation(from location: CLLocation) -> TrainStation? {
		closestStation(from: location, stations: stations)
	}

	public func closestStation(from location: CLLocation,
							   stations: [TrainStation]) -> TrainStation? {
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

	public func closestStation(from location: CLLocation, route: Route) -> TrainStation? {
		switch route {
			case .red:
				return closestStation(from: location, stations: redLineStations)
			case .green:
				return closestStation(from: location, stations: greenLineStations)
		}
	}
}

public struct TrainsByDirection {
	public let trainStation: TrainStation

	public let inbound: [Train]
	public let outbound: [Train]
	public let message: String?	// XML api gives message

	public init(trainStation: TrainStation,
				inbound: [Train],
				outbound: [Train],
				message: String? = nil) {
		self.trainStation = trainStation
		self.inbound = inbound
		self.outbound = outbound
		self.message = message
	}
}
