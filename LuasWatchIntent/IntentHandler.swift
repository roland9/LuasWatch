//
//  Created by Roland Gropmair on 23/12/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Intents
import LuasKit

public protocol IntentCoordinatorDelegate: class {
	func didFail(_ error: IntentCoordinatorDelegateError)
	func didGetTrains(_ trains: TrainsByDirection)
}

public enum IntentCoordinatorDelegateError {
	case errorLocationServicesNotEnabled
	case errorLocationAccessDenied
	case errorLocationManagerError(Error)
	case errorLocationAuthStatus(CLAuthorizationStatus)

	case errorGettingLocation(String)

	case errorGettingStation(String)		// in case the user is too far away

	case errorGettingDueTimes(String)
}

class IntentHandler: INExtension, NextLuasIntentHandling {

	private let location = Location()
	private var coordinator: IntentCoordinator!

	private var completion: ((NextLuasIntentResponse) -> Void)?

	override func handler(for intent: INIntent) -> Any {
		// This is the default implementation.  If you want different objects to handle different intents,
		// you can override this and return the handler you want for that particular intent.

		return self
	}

	func handle(intent: NextLuasIntent, completion: @escaping (NextLuasIntentResponse) -> Void) {
		coordinator = IntentCoordinator(location: location)
		coordinator.delegate = self
		self.completion = completion

		coordinator.start()
	}
}

extension IntentHandler: IntentCoordinatorDelegate {

	func didFail(_ error: IntentCoordinatorDelegateError) {
		let nextLuas = NextLuas(identifier: nil, display: "Next Luas Error")
		nextLuas.failureText = "custom failure"

		completion?(.failure(nextLuases: [nextLuas]))
	}

	func didGetTrains(_ trains: TrainsByDirection) {
		let nextLuas = NextLuas(identifier: nil, display: "Next Luases")

		var train: Train?


		if let nextInbound = trains.inbound.first {
			train = nextInbound
		} else if let nextOutbound = trains.outbound.first {
			train = nextOutbound
		}

		guard let nextTrain = train else {
			// ??
			return
		}

		nextLuas.destination = nextTrain.destination
		nextLuas.minutes = nextTrain.dueTimeDescription

		completion?(.success(nextLuases: [nextLuas]))
	}

}
