//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation

public enum Route: String, Codable, Equatable, Sendable {
  case red, green
}

extension Route {

  public init?(rawValue: String) {
    if rawValue.lowercased() == "red" {
      self = .red
    } else if rawValue.lowercased() == "green" {
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
