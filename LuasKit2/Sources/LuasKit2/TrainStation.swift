//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

public struct TrainStation: CustomStringConvertible, Hashable, Identifiable, Sendable {

  public var id: String {
    stationIdShort
  }

  public enum StationType: String, Sendable {
    case twoway, oneway, terminal
  }

  public let stationIdShort: String  // that is the 'id' required for the API
  public let shortCode: String  // three-letter code, such as 'RAN'; for the XML API
  public let route: Route
  public let name: String
  public let location: CLLocation
  public let stationType: StationType

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
}
