//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public struct TrainsByDirection {
	public let trainStation: TrainStation

	public let inbound: [Train]
	public let outbound: [Train]
	public let message: String?	// XML api gives message

	public init(trainStation: TrainStation,
				inbound: [Train],
				outbound: [Train],
				message: String? = nil) {
		self.trainStation = trainStation
		self.inbound = inbound
		self.outbound = outbound
		self.message = message
	}

    public func shortcutOutput(direction: Direction) -> String {
        var output = ""

        if direction == .inbound || direction == .both {
            output += inbound
                .compactMap { $0.destinationDueTimeDescription + ".\n" }
                .joined()
        }

        if direction == .outbound || direction == .both {
            output += outbound
                .compactMap { $0.destinationDueTimeDescription + ".\n" }
                .joined()
        }

        return output.count > 0 ? output : "No trains found for \(trainStation.name) LUAS stop.\n"
    }
}
