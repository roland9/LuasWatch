//
//  Created by Roland Gropmair on 09/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

import LuasKitIOS

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

extension CoordinatorAppIntent: LocationDelegate {

    func didFail(_ delegateError: LocationDelegateError) {

        latestLocation = nil

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

    func didGetLocation(_ location: CLLocation) {

        latestLocation = location

        //////////////////////////////////
        // step 2: we have location -> now find station
        let allStations = TrainStations.sharedFromFile

        if let station = MyUserDefaults.userSelectedSpecificStation() {
            print("step 2a: closest station, but specific one user selected before")
            handle(station, location)

        } else {
            print("step 2b: closest station, doesn't matter which line")
            if let closestStation = allStations.closestStation(from: location) {
                print("\(#function): found closest station <\(closestStation.name)>")

                handle(closestStation, location)
            } else {

                // no station found -> user too far away!
                trains = nil
                appState.state = .errorGettingStation(LuasStrings.tooFarAway)
            }
        }

    }

    internal func handleAppIntent(_ closestStation: TrainStation,
                                  _ location: CLLocation) async -> MyState {

        return await withCheckedContinuation {
            (continuation: CheckedContinuation<MyState, Never>) in

            LuasAPI2.dueTime(for: closestStation) { (result) in

                DispatchQueue.main.async {
                    switch result {
                        case .error(let error):
                            print("\(#function): \(error)")
                            continuation.resume(returning: .errorGettingDueTimes(closestStation,
                                                                                 error.count > 0 ? error : LuasStrings.errorGettingDueTimes))

                        case .success(let trains):
                            print("\(#function): \(trains)")
                            continuation.resume(returning: .foundDueTimes(trains, location))
                    }
                }
            }
        }
    }

    fileprivate func handle(_ closestStation: TrainStation,
                            _ location: CLLocation) {
        // use different states: if we have previously loaded a list of trains, let's preserve it in the UI while loading

        // sometimes crash on watchOS 9
        // [SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in

            guard let self = self else { return }

            // WIP don't use intermediate states for AppIntent?
//            if let trains = self.trains {
//                self.appState.state = .updatingDueTimes(trains, location)
//            } else {
//                self.appState.state = .gettingDueTimes(closestStation, location)
//            }

            //////////////////////////////////
            // step 3: get due times from API
            LuasAPI2.dueTime(for: closestStation) { [weak self] (result) in

                DispatchQueue.main.async {
                    switch result {
                        case .error(let error):
                            print("\(#function): \(error)")
                            self?.trains = nil
                            self?.appState.state = .errorGettingDueTimes(closestStation,
                                                                         error.count > 0 ? error : LuasStrings.errorGettingDueTimes)

                        case .success(let trains):
                            print("\(#function): \(trains)")
                            self?.trains = trains
                            self?.appState.state = .foundDueTimes(trains, location)
                    }
                }
            }
        }
    }
}
