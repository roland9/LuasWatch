//
//  Created by Roland Gropmair on 26/12/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

/// persist the chosen direction (per station) in UserDefaults
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
      logger.info("updating directions \(directions)")

      directions[station] = direction.rawValue
      userDefaults.set(directions, forKey: userDefaultsKey)
    } else {
      // first time we set anything: start from scratch with dictionary with only one entry
      logger.info("setting direction \(direction)")

      let direction: [String: Int] = [station: direction.rawValue]
      userDefaults.set(direction, forKey: userDefaultsKey)
    }
  }
}
