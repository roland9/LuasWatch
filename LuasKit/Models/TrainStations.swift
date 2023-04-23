//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation
import CoreLocation

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

    private init(fromFile fileName: String) {
        guard
            let luasStopsFile = Bundle.main.url(forResource: "JSON/" + fileName, withExtension: "json"),
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

#if DEBUG
    // for Unit Tests only
    public static let sharedFromFileForTests = Self.fromFileForTests()

    private static func fromFileForTests() -> TrainStations {

#if os(iOS)
        let identifier = "ie.mapps.LuasKitIOSTests"
#endif

#if os(watchOS)
        let identifier = "ie.mapps.LuasWatchWatchKitExtensionTests"
#endif

        guard
            let luasStopsFile = Bundle(identifier: identifier)!
                .url(forResource: "JSON/luasStops", withExtension: "json"),
            let data = try? Data(contentsOf: luasStopsFile),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
            let stationsArray = json["stations"] as? [JSONDictionary]
        else { fatalError("could not parse JSON file") }

        return TrainStations(stations: trainStations(from: stationsArray))
    }
#endif
}
