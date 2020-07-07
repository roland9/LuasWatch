//
//  Created by Roland Gropmair on 07.07.20.
//  Copyright © 2020 mApps.ie. All rights reserved.
//

import Foundation

class DirectionState: ObservableObject {

	enum Direction {
		case both, inbound, outbound
	}

	var direction: Direction = .both

	public init() {}

	public init(_ direction: Direction) {
		self.direction = direction
	}

	func text() -> String {
		switch direction {
			case .both:
				return "Both directions"
			case .inbound:
				return "Inbound"
			case .outbound:
				return "Outbound"
		}
	}
}
