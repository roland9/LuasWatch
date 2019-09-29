//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKit

class Coordinator: NSObject {

	let appState: AppState
	var location: Location
	var timer: Timer?

	var trains: TrainsByDirection?

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

extension Coordinator: LocationDelegate {

	func didFail(_ error: Error) {
		appState.state = .errorGettingLocation(error)
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
//	TODO should we nil it?			trains = nil
				self?.appState.state = .errorGettingDueTimes(error)

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
			appState.state = .errorGettingStation(LuasErrors.errorLocationTooFarAway)
		}
	}

}
