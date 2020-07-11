//
//  Created by Roland Gropmair on 07.07.20.
//  Copyright © 2020 mApps.ie. All rights reserved.
//

import Foundation

class DirectionState: ObservableObject {

	enum Direction: Int {
		case both, inbound, outbound
	}

	var direction: Direction = .both

	public init() {}

	public init(_ direction: Direction) {
		self.direction = direction
	}
}

extension DirectionState.Direction {

	func text() -> String {
		switch self {
			case .both:
				return "Both directions"
			case .inbound:
				return "Inbound"
			case .outbound:
				return "Outbound"
		}
	}

	func next() -> DirectionState.Direction {
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

extension DirectionState {

	fileprivate static let userDefaultsKey = "DirectionStates"

	static func direction(for station: String) -> Direction {
		let userDefaults = UserDefaults.standard

		if let directions = userDefaults.object(forKey: userDefaultsKey) as? [String: Int],
			let direction = directions[station] {
			return DirectionState.Direction(rawValue: direction)!
		}

		// haven't found a value for this station: fallback default is `.both`
		return .both
	}

	static func setDirection(for station: String, to direction: Direction) {
		let userDefaults = UserDefaults.standard

		if var directions = userDefaults.object(forKey: userDefaultsKey) as? [String: Int] {
			directions[station] = direction.rawValue
			userDefaults.set(directions, forKey: userDefaultsKey)
		} else {
			// first time we set anything: start from scratch with dictionary with only one entry
			let direction: [String: Int] = [station: direction.rawValue]
			userDefaults.set(direction, forKey: userDefaultsKey)
		}

	}
}
