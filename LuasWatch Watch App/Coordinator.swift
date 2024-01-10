//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKit

class Coordinator: NSObject {

    private let api = LuasAPI(apiWorker: RealAPIWorker())

	private let appState: AppState
	private var location: Location
	private var timer: Timer?

    private let appModel: AppModel

	private var latestLocation: CLLocation?

	private var trains: TrainsByDirection?

    static let refreshInterval = 12.0

	init(appState: AppState,
         appModel: AppModel,
		 location: Location) {
		self.appState = appState
        self.appModel = appModel
		self.location = location
    }

    func start() {

        // ///////////////////////////////
        // step 1: if required, determine location
        location.delegate = self

        if appModel.appMode == .closest ||
            appModel.appMode == .closestOtherLine {

            myPrint("need location for current appMode \(appModel.appMode) -> prompt for location auth")
            /// we need location updates in these cases
            location.promptLocationAuth()

        } else {
            myPrint("no location needed for the current appMode \(appModel.appMode)")
        }

        /// we will call location.start() once user has authorized location access

        NotificationCenter.default.addObserver(
            forName: Notification.Name("LuasWatch.RetriggerTimer"),
            object: nil, queue: nil) { _ in
                self.retriggerTimer()
            }
	}

	func invalidateTimer() {
		timer?.invalidate()
	}

	func scheduleTimer() {
		// fire right now...
		timerDidFire()

		// ... but also schedule for later
        timer = Timer.scheduledTimer(timeInterval: Self.refreshInterval,
									 target: self, selector: #selector(timerDidFire),
									 userInfo: nil, repeats: true)
	}

	func retriggerTimer() {
        myPrint(#function)
        
		timer?.invalidate()

		// fire right now...
		timerDidFire()

		// ... and then schedule again for regular interval
		timer = Timer.scheduledTimer(timeInterval: Self.refreshInterval,
									 target: self, selector: #selector(timerDidFire),
									 userInfo: nil, repeats: true)
	}

	@objc func timerDidFire() {

		guard appState.isStationsModalPresented == false else {
			myPrint("💔 StationsModal is up (isStationsModalPresented == true) -> ignore location update timer")
			return
		}

		// if user has selected a specific station
//        if let station = MyUserDefaults.userSelectedSpecificStation() {
        if let station = appModel.appMode.isSpecificStation {

            // the location we have is not too old -> don't wait for another location update
            if let latestLocation,
               latestLocation.isQuiteRecent() {
                myPrint("🥳 we have user selected station & recent location -> skip location update")
                handle(station, latestLocation)
            } else {
                myPrint("😇 user has selected specific station & only outdated or no location \(latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update")
                location.update()
            }

        } else {
			// user has NOT selected a specific station

            if let latestLocation = latestLocation,
               latestLocation.isQuiteRecent() {
                // we have a location that's not too old
                myPrint("🥳 user has NOT selected specific station & we have a recent location -> skip location update")
                didGetLocation(latestLocation)
            } else {
                myPrint("😇 user has NOT selected specific station & only outdated location \(latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update")
                location.update()
            }
		}
	}
}

extension CLLocation {

    func isQuiteRecent() -> Bool {
        timestamp.timeIntervalSinceNow > -20.0
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

		latestLocation = nil

		switch delegateError {

			case .locationServicesNotEnabled:
                appModel.updateWithAnimation(to: .errorGettingLocation(LuasStrings.locationServicesDisabled))

			case .locationAccessDenied:
                appModel.updateWithAnimation(to: .errorGettingLocation(LuasStrings.locationAccessDenied))

			case .locationManagerError(let error):
                appModel.updateWithAnimation(to: .errorGettingLocation(error.localizedDescription))

			case .authStatus(let authStatusError):
				if let errorMessage = authStatusError.localizedErrorMessage() {
                    appModel.updateWithAnimation(to: .errorGettingLocation(LuasStrings.gettingLocationAuthError(errorMessage)))
				} else {
                    appModel.updateWithAnimation(to: .errorGettingLocation(LuasStrings.gettingLocationOtherError))
			}
		}
	}

    func didEnableLocation() {
        location.start()
    }

	func didGetLocation(_ location: CLLocation) {

		latestLocation = location

		// ///////////////////////////////
		// step 2: we have location -> now find station
		let allStations = TrainStations.sharedFromFile


//		if let station = MyUserDefaults.userSelectedSpecificStation() {
        if let station = appModel.appMode.isSpecificStation {
			myPrint("step 2a: got location now, but user selected specific station before -> use this station now")
			handle(station, location)

		} else {
			myPrint("step 2b: got location; find closest station (no matter which line)")

			if let closestStation = allStations.closestStation(from: location) {
				myPrint("found closest station <\(closestStation.name)>")
				handle(closestStation, location)

			} else {
                myPrint("step 2c: no station found -> user too far away")
				trains = nil
				appModel.updateWithAnimation(to: .errorGettingStation(LuasStrings.tooFarAway))
			}
		}

	}

	fileprivate func handle(_ closestStation: TrainStation,
							_ location: CLLocation) {
		// use different states: if we have previously loaded a list of trains, let's preserve it in the UI while loading

		// sometimes crash on watchOS 9
		// [SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior
        //		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            if let trains = self.trains {
                appModel.updateWithAnimation(to: .updatingDueTimes(trains, location))
            } else {
                appModel.updateWithAnimation(to: .loadingDueTimes(closestStation, location))
            }

        // ///////////////////////////////
        // step 3: get due times from API
        Task {

            do {
                let trains = try await self.api.dueTimes(for: closestStation)

                myPrint("got trains \(trains)")
                self.trains = trains
                appModel.updateWithAnimation(to: .foundDueTimes(trains, location))

            } catch {

                trains = nil
                myPrint("caught error \(error.localizedDescription)")

                if let apiError = error as? APIError {

                    switch apiError {
                        case .noTrains(let message):
                            appModel.updateWithAnimation(to:
                                    .errorGettingDueTimes(closestStation,
                                                          message.count > 0 ? message : LuasStrings.errorGettingDueTimes))

                        case .invalidXML:
                            appModel.updateWithAnimation(
                                to: .errorGettingDueTimes(closestStation, "Error reading server response"))
                    }
                } else {
                    appModel.updateWithAnimation(to:
                            .errorGettingDueTimes(closestStation, LuasStrings.errorGettingDueTimes))
                }
            }
        }
    }
}

extension Coordinator: AppStateChangeable {

    func didChange(to state: MyState) {
        if case .gettingLocation = state {
            location.promptLocationAuth()
        }
    }
}
