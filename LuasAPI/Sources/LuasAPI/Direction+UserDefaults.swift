//
//  Created by Roland Gropmair on 26/12/2024.
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
