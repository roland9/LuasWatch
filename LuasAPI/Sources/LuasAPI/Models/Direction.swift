//
//  Created by Roland Gropmair on 07.07.20.
//  Copyright © 2020 mApps.ie. All rights reserved.
//

import AppIntents
import Foundation

public enum Direction: Int, Equatable, CaseIterable, Codable, CustomStringConvertible {

  case both, inbound, outbound

  public var description: String {
    switch self {
      case .both:
        return "Both directions"
      case .inbound:
        return "Inbound"
      case .outbound:
        return "Outbound"
    }
  }

  public var next: Direction {
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

//@available(iOSApplicationExtension 16.0, *)
//extension Direction: AppEnum {
//
//  static var typeDisplayName: LocalizedStringResource = "Direction"
//
//  public static var typeDisplayRepresentation = TypeDisplayRepresentation(
//    name: "Direction of the train (for stations that have both)")
//
//  public static var caseDisplayRepresentations: [Direction: DisplayRepresentation] {
//    [.inbound: "inbound trains", .outbound: "outbound trains", .both: "both directions"]
//  }
//}
