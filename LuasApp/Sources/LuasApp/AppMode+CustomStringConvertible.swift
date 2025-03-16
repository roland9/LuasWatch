//
//  Created by Roland Gropmair on 05/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

extension AppMode: CustomStringConvertible {

  public var description: String {
    switch self {
    case .closest:
      return "closest"
    case .closestOtherLine:
      return "closestOtherLine"
    case .favourite(let station):
      return "favourite: \(station.name)"
    case .nearby(let station):
      return "nearby: \(station.name)"
    case .specific(let station):
      return "specific: \(station.name)"
    case .recents(let station):
      return "recents: \(station.name)"
    }
  }
}
