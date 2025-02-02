//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

typealias JSONDictionary = [String: Any]

public struct TrainStations: Sendable {

  // MARK: - Properties

  public let allStations: [TrainStation]

  // MARK: - Initializers

  public init() {
    // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#Access-a-resource-in-code
    guard let url = Bundle.module.url(forResource: "luasStops", withExtension: "json") else {
      fatalError("expected luasStops.json file in bundle")
    }

    self.init(url: url)
  }

  internal init(url: URL) {
    guard let data = try? Data(contentsOf: url),
          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
          let stationsArray = json["stations"] as? [JSONDictionary] else {
      fatalError("could not parse JSON file")
    }

    self.allStations = Self.trainStations(from: stationsArray)
  }

  internal init(stations: [TrainStation]) {
    self.allStations = stations
  }

  // MARK: - Private Methods

  fileprivate static func trainStations(from stationsArray: [JSONDictionary]) -> [TrainStation] {

    stationsArray.compactMap { (station) in

      var stationTypeValue: TrainStation.StationType = .twoway

      if let stationTypeString = station["type"] as? String,
         let stationType = TrainStation.StationType(rawValue: stationTypeString)
      {
        stationTypeValue = stationType
      }

      guard
        let stationIdShort = station["stationIdShort"] as? String,
        let shortCode = station["shortCode"] as? String,
        let routeRawValue = station["route"] as? String,
        let route = Route(rawValue: routeRawValue),
        let name = station["name"] as? String,
        let lat = station["lat"] as? Double,
        let long = station["long"] as? Double
      else {
        assertionFailure("could not parse station")
        return nil
      }

      return TrainStation(
        stationIdShort: stationIdShort,
        shortCode: shortCode,
        route: route,
        name: name,
        location: CLLocation(
          latitude: CLLocationDegrees(lat),
          longitude: CLLocationDegrees(long)),
        stationType: stationTypeValue)
    }
  }

  // MARK: - Helpers

  public var redLineStations: [TrainStation] {
    allStations
      .filter { $0.route == .red }
  }

  public var greenLineStations: [TrainStation] {
    allStations
      .filter { $0.route == .green }
  }

  public func closestStation(from location: CLLocation) -> TrainStation? {
    allStations.closestStation(from: location)
  }

  public func closestStation(from location: CLLocation, route: Route) -> TrainStation? {
    switch route {
      case .red:
        return redLineStations.closestStation(from: location)
      case .green:
        return greenLineStations.closestStation(from: location)
    }
  }

  func closestStationsSorted(from location: CLLocation) -> [TrainStation] {
    allStations.sorted { (station1, station2) -> Bool in
      station1.location.distance(from: location) < station2.location.distance(from: location)
    }
  }

  public func station(shortCode: String) -> TrainStation? {
    allStations
      .filter { $0.shortCode == shortCode }
      .first
  }
}

private extension Array where Element == TrainStation {

  func closestStation(from location: CLLocation) -> TrainStation? {
    var closestStationSoFar: TrainStation?

    self.forEach { (station) in
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
