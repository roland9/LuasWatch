//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation

public struct Train: CustomStringConvertible, Hashable, Codable {

    public var id: String {
        direction + dueTime
    }

    public let destination: String
    public let direction: String
    public let dueTime: String

    public var description: String {
        "\(destination.replacingOccurrences(of: "LUAS ", with: "")): \'\(dueTimeDescription)\'"
    }

    public var dueTimeDescription: String {
        "\(destination.replacingOccurrences(of: "LUAS ", with: "")): " +
        ((dueTime.lowercased() == "due") ? "Due" : "\(dueTime) mins")
    }

    public var destinationDescription: String {
        destination.replacingOccurrences(of: "LUAS ", with: "")
    }

    public var dueTimeDescription2: String {
        (dueTime.lowercased() == "due") ? "Due" : dueTime
    }

    public var destinationDueTimeDescription: String {
        "Luas to \(destination) \(dueTime.lowercased() == "due" ? "is Due" : "in \(dueTime)")"
    }

    public init(destination: String, direction: String, dueTime: String) {
        self.destination = destination
        self.direction = direction
        self.dueTime = dueTime
    }
}
