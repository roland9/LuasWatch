//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation

public struct TrainStations {

    public let stations: [TrainStation]

    public static let sharedFromFile = Self.fromFile()

    private static func fromFile() -> TrainStations {
        TrainStations(fromFile: "luasStops")
    }

    fileprivate static func trainStations(from stationsArray: [JSONDictionary]) -> [TrainStation] {
        // swiftlint:disable force_cast
        stationsArray.compactMap { (station) in

            var stationTypeValue: TrainStation.StationType = .twoway

            if let stationTypeString = station["type"] as? String,
                let stationType = TrainStation.StationType(rawValue: stationTypeString)
            {
                stationTypeValue = stationType
            }

            return TrainStation(
                stationId: station["stationId"] as! String,
                stationIdShort: station["stationIdShort"] as! String,
                shortCode: station["shortCode"] as! String,
                route: Route(station["route"] as! String)!,
                name: station["name"] as! String,
                location: CLLocation(
                    latitude: CLLocationDegrees(station["lat"] as! Double),
                    longitude: CLLocationDegrees(station["long"] as! Double)),
                stationType: stationTypeValue)
        }
        // swiftlint:enable force_cast
    }

    private init(fromFile fileName: String) {
        let identifier = "ie.mapps.LuasKit"

        guard
            let luasStopsFile = Bundle(identifier: identifier)?
                .url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: luasStopsFile),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
            let stationsArray = json["stations"] as? [JSONDictionary]
        else { fatalError("could not parse JSON file") }

        self.stations = Self.trainStations(from: stationsArray)
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

    public func closestStation(
        from location: CLLocation,
        stations: [TrainStation]
    ) -> TrainStation? {
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

    public func station(shortCode: String) -> TrainStation? {
        stations
            .filter { $0.shortCode == shortCode }
            .first
    }

    public static var unknown: TrainStation {
        TrainStation(
            stationId: "id",
            stationIdShort: "unknown",
            shortCode: "unknown",
            route: .green,
            name: "Unknown",
            location: CLLocation(
                latitude: CLLocationDegrees(53.3163934083453),
                longitude: CLLocationDegrees(-6.25344151996991)))
    }
}
