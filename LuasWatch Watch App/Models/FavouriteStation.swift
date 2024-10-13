//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import SwiftData

typealias StationShortCode = String

@Model
final class FavouriteStation: CustomDebugStringConvertible {

  let shortCode: StationShortCode
  let dateAdded: Date

  public init(shortCode: StationShortCode) {
    self.shortCode = shortCode
    self.dateAdded = Date()
  }

  var debugDescription: String {
    "Favourite Station: shortCode \"\(shortCode)\""
  }
}
