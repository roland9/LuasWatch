//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

public enum Route: Int, Codable {
  case red, green
}

extension Route {
  init?(_ routeString: String) {
    if routeString == "Red" {
      self = .red
    } else if routeString == "Green" {
      self = .green
    } else {
      return nil
    }
  }

  public var other: Route {
    switch self {
    case .red:
      return .green
    case .green:
      return .red
    }
  }
}
