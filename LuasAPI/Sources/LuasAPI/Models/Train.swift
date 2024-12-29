//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation

public struct Train: CustomStringConvertible, Hashable, Codable, Sendable {

  // MARK: - Properties
  
  public let destination: String
  public let direction: String
  public let dueTime: String

  public var id: String {
    UUID().uuidString
  }

  // MARK: - Initializer

  public init(destination: String, direction: String, dueTime: String) {
    self.destination = destination
    self.direction = direction
    self.dueTime = dueTime
  }

  // MARK: - Computed Properties

  public var description: String {
    "\(destinationDescription): "
    + ((dueTime.lowercased() == "due") ? "Due" : "\(dueTime) mins")
  }

  public var dueTimeDescriptionShort: String {
    (dueTime.lowercased() == "due") ? "Due" : dueTime
  }

  public var destinationDescription: String {
    destination.replacingOccurrences(of: "LUAS ", with: "")
  }

  public var destinationDueTimeDescription: String {
    "Luas to \(destinationDescription) \(dueTime.lowercased() == "due" ? "is Due" : "in \(dueTime)")"
  }
}
