//
//  Created by Roland Gropmair on 07.07.20.
//  Copyright © 2020 mApps.ie. All rights reserved.
//

import AppIntents
import Foundation

public enum Direction: Int, CaseIterable, Codable {

  case both, inbound, outbound
}

@available(iOSApplicationExtension 16.0, *)
extension Direction: AppEnum {

  static var typeDisplayName: LocalizedStringResource = "Direction"

  public static var typeDisplayRepresentation = TypeDisplayRepresentation(
    name: "Direction of the train (for stations that have both)")

  public static var caseDisplayRepresentations: [Direction: DisplayRepresentation] {
    [.inbound: "inbound trains", .outbound: "outbound trains", .both: "both directions"]
  }
}

extension Direction: CustomStringConvertible {

  public var description: String {
    return text()
  }

  public func text() -> String {
    switch self {
    case .both:
      return "Both directions"
    case .inbound:
      return "Inbound"
    case .outbound:
      return "Outbound"
    }
  }

  public func next() -> Direction {
    switch self {
    case .both:
      return .inbound
    case .inbound:
      return .outbound
    case .outbound:
      return .both
    }
  }
}

extension Direction {

  fileprivate static let userDefaultsKey = "DirectionStates"

  public static func direction(for station: String) -> Direction {
    let userDefaults = UserDefaults.standard

    if let directions = userDefaults.object(forKey: userDefaultsKey) as? [String: Int],
      let direction = directions[station]
    {
      return Direction(rawValue: direction)!
    }

    // haven't found a value for this station: fallback default is `.both`
    return .both
  }

  public static func setDirection(for station: String, to direction: Direction) {
    let userDefaults = UserDefaults.standard

    if var directions = userDefaults.object(forKey: userDefaultsKey) as? [String: Int] {
      directions[station] = direction.rawValue
      userDefaults.set(directions, forKey: userDefaultsKey)
      myPrint("updating directions \(directions)")
    } else {
      // first time we set anything: start from scratch with dictionary with only one entry
      let direction: [String: Int] = [station: direction.rawValue]
      userDefaults.set(direction, forKey: userDefaultsKey)
      myPrint("setting direction \(direction)")
    }
  }
}
