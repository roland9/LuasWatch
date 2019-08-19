//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKit

class MainCoordinator: NSObject {

	let appState: AppState
	var location: Location!
	var timer: Timer?

	init(appState: AppState) {
		self.appState = appState
	}

	func start() {

		// step 1: determine location
		location = Location()
		location.delegate = self

		location.start()

		// set timer to update periodically
		timer = Timer.scheduledTimer(timeInterval: 15.0,
										 target: self, selector: #selector(fireTimer),
										 userInfo: nil, repeats: true)
	}

	@objc func fireTimer() {
		location.update()
	}
}

extension MainCoordinator: LocationDelegate {

	func didFail(_ error: Error) {
		appState.state = .errorGettingLocation(error)
	}

	func didGetLocation(_ location: CLLocation) {

		appState.state = .gettingStation(location)

		// step 2: we have location -> now find closest station
		let allStations = TrainStations(fromFile: "luasStops")
		let closestStation = allStations.closestStation(from: location)
		print("\(#function): found closest station <\(closestStation.name)>")

		appState.state = .gettingDueTimes(closestStation)

		// step 3: get due times from API
		LuasAPI.dueTime(for: closestStation) { [weak self] (result) in
			switch result {
			case .error(let error):
				print("\(#function): \(error)")
				self?.appState.state = .errorGettingDueTimes(error)

			case .success(let trains):
				print("\(#function): \(trains)")
				self?.appState.state = .foundDueTimes(trains)
			}
		}

	}

}
