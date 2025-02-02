//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

public struct TrainStation: CustomStringConvertible, Hashable, Identifiable, Sendable {

  public let stationIdShort: String  // that is the 'id' required for the API
  public let shortCode: String  // three-letter code, such as 'RAN'; for the XML API
  public let route: Route
  public let name: String
  public let location: CLLocation
  public let stationType: StationType

  public init(
    stationIdShort: String,
    shortCode: String,
    route: Route,
    name: String,
    location: CLLocation,
    stationType: StationType = .twoway
  ) {
    self.stationIdShort = stationIdShort
    self.shortCode = shortCode
    self.route = route
    self.name = name
    self.location = location
    self.stationType = stationType
  }

  // need custom implementation because location does not compare lat/long when checking for equatable
  static public func == (lhs: TrainStation, rhs: TrainStation) -> Bool {
    lhs.stationIdShort == rhs.stationIdShort &&
    lhs.shortCode == rhs.shortCode &&
    lhs.route == rhs.route &&
    lhs.name == rhs.name &&
    lhs.location.coordinate.latitude == rhs.location.coordinate.latitude &&
    lhs.location.coordinate.longitude == rhs.location.coordinate.longitude &&
    lhs.stationType == rhs.stationType
  }

  public var id: String {
    stationIdShort
  }

  public enum StationType: String, Sendable, Equatable {
    case twoway, oneway, terminal
  }

  public var description: String {
    "<\(stationIdShort)> \"\(name)\"  (\(location.coordinate.latitude)/\(location.coordinate.longitude))  type: .\(stationType)"
  }

  public var isFinalStop: Bool {
    stationType == .terminal
  }

  public var allowsSwitchingDirection: Bool {
    stationType == .twoway
  }

  // will return nil if the distance is quite small, i.e. if the user is quite close to the station
  public func distance(from userLocation: CLLocation) -> String? {
    let minimumDistance = Measurement<UnitLength>(value: 200, unit: .meters)
    let distance = Measurement<UnitLength>(
      value: location.distance(from: userLocation),
      unit: .meters)

    guard distance > minimumDistance else { return nil }

    let formatter = MeasurementFormatter()
    formatter.locale = Locale(identifier: "en_IE")  // not correct: we hard coded the locale here!
    formatter.unitOptions = .naturalScale
    formatter.unitStyle = .medium
    formatter.numberFormatter.usesSignificantDigits = true
    formatter.numberFormatter.maximumSignificantDigits = 1

    return formatter.string(from: distance)
  }

  public static var unknown: TrainStation {
    TrainStation(
      stationIdShort: "unknown",
      shortCode: "unknown",
      route: .green,
      name: "Unknown",
      location: CLLocation(
        latitude: CLLocationDegrees(53.3163934083453),
        longitude: CLLocationDegrees(-6.25344151996991))
    )
  }
}
