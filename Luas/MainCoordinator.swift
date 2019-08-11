//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

class MainCoordinator: NSObject {

	let appState: AppState
	var location: Location!

	init(appState: AppState) {
		self.appState = appState
	}

	func start() {

		// step 1: determine location
		location = Location()
		location.delegate = self
		
		location.start()
	}
}

extension MainCoordinator: LocationDelegate {

	func didFail(_ error: Error) {
		appState.state = .errorGettingLocation(error)
	}

	func didGetLocation(_ location: CLLocation) {

		appState.state = .gettingStation(location)

		// now that we have location: get closest station
		let allStations = TrainStations(fromFile: "luasStops")
		let closestStation = allStations.closestStation(from: location)
		print("\(#function): found cloest station <\(closestStation.name)>")

		appState.state = .gettingDepartureTimes(closestStation)

		// get departure times
		LuasAPI.dueTime(for: closestStation.stationId) { [weak self] (result) in
			switch result {
			case .error(let error):
				print("\(#function): \(error)")

			case .success(let trains):
				print("\(#function): \(trains)")
				self?.appState.state = .foundDepartureTimes(trains)
			}
		}

	}

}
