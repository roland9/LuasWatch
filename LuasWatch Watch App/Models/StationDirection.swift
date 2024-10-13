//
//  Created by Roland Gropmair on 04/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import LuasKit
import SwiftData

@Model
final class StationDirection: CustomDebugStringConvertible {

  let shortCode: StationShortCode
  var direction: Direction

  init(shortCode: StationShortCode, direction: Direction) {
    self.shortCode = shortCode
    self.direction = direction
  }

  var debugDescription: String {
    "Station Direction: \(direction)"
  }
}
