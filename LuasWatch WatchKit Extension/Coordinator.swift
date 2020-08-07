//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKit

class Coordinator: NSObject {

	private let appState: AppState
	private var location: Location
	private var timer: Timer?

	private var trains: TrainsByDirection?

	init(appState: AppState,
		 location: Location) {
		self.appState = appState
		self.location = location
	}

	func start() {

		// step 1: determine location
		location.delegate = self

		location.start()
	}

	func invalidateTimer() {
		timer?.invalidate()
	}

	func scheduleTimer() {
		// fire right now...
		timerDidFire()

		// ... but also schedule for later
		timer = Timer.scheduledTimer(timeInterval: 12.0,
									 target: self, selector: #selector(timerDidFire),
									 userInfo: nil, repeats: true)
	}

	@objc func timerDidFire() {
		location.update()
	}
}

extension CLAuthorizationStatus {
	func localizedErrorMessage() -> String? {
		switch self {
			case .notDetermined:
				return NSLocalizedString("auth status not determined (yet)", comment: "")

			case .restricted:
				return NSLocalizedString("auth status restricted", comment: "")

			case .denied:
				return NSLocalizedString("auth status denied", comment: "")

			default:
				return nil
		}
	}
}
extension Coordinator: LocationDelegate {

	func didFail(_ delegateError: LocationDelegateError) {
		switch delegateError {

			case .locationServicesNotEnabled:
				appState.state = .errorGettingLocation(LuasStrings.locationServicesDisabled)

			case .locationAccessDenied:
				appState.state = .errorGettingLocation(LuasStrings.locationAccessDenied)

			case .locationManagerError(let error):
				appState.state = .errorGettingLocation(error.localizedDescription)

			case .authStatus(let authStatusError):
				if let errorMessage = authStatusError.localizedErrorMessage() {
					appState.state = .errorGettingLocation(LuasStrings.gettingLocationAuthError(errorMessage))
				} else {
					appState.state = .errorGettingLocation(LuasStrings.gettingLocationOtherError)
			}
		}
	}

	fileprivate func handle(_ closestStation: TrainStation) {
		// use different states: if we have previously loaded a list of trains, let's preserve it in the UI while loading
		if let trains = trains {
			appState.state = .updatingDueTimes(trains)
		} else {
			appState.state = .gettingDueTimes(closestStation)
		}

		// step 3: get due times from API
		LuasAPI.dueTime(for: closestStation) { [weak self] (result) in
			switch result {
				case .error(let error):
					print("\(#function): \(error)")
					self?.trains = nil
					self?.appState.state = .errorGettingDueTimes(error.count > 0 ? error : LuasStrings.errorGettingDueTimes)

				case .success(let trains):
					print("\(#function): \(trains)")
					self?.trains = trains
					self?.appState.state = .foundDueTimes(trains)
			}
		}
	}

	func didGetLocation(_ location: CLLocation) {

		// step 2: we have location -> now find closest station
		let allStations = TrainStations(fromFile: "luasStops")

		if let closestStation = allStations.closestStation(from: location) {
			print("\(#function): found closest station <\(closestStation.name)>")

			handle(closestStation)
		} else {

			// no station found -> user too far away!
			trains = nil
			appState.state = .errorGettingStation(LuasStrings.tooFarAway)
		}
	}

}
