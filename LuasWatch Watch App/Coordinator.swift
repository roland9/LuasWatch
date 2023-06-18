//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKit

class Coordinator: NSObject {

    internal let appState: AppState
    internal var latestLocation: CLLocation?
    internal var timer: Timer?

    private var locationHandler: LocationHandler
    private let api = LuasAPI(apiWorker: RealAPIWorker())
    private var trains: TrainsByDirection?

    private static let allStations = TrainStations.sharedFromFile

    init(appState: AppState, locationHandler: LocationHandler) {
        self.appState = appState
        self.locationHandler = locationHandler
    }

    func start() {

        // WIP find a nicer way to handle timers - Combine?
        NotificationCenter.default
            .addObserver(forName: Notification.Name("LuasWatch.RetriggerTimer"),
                         object: nil, queue: nil) { _ in
                self.retriggerTimer()
            }

        Task {
            do {
                let location = try await locationHandler.requestLocation()
                latestLocation = location

                if let station = MyUserDefaults.userSelectedSpecificStation() {
                    print("user selected a specific station")
                    handle(station, location)

                } else {
                    print("find closest station for this location (red or green line)")
                    if let closestStation = Self.allStations.closestStation(from: location) {
                        print("\(#function): found closest station <\(closestStation.name)>")

                        handle(closestStation, location)
                    } else {

                        // no station found -> user too far away!
                        trains = nil
                        appState.updateWithAnimation(to: .errorGettingStation(LuasStrings.tooFarAway))
                    }
                }

            } catch let error as LocationDelegateError {

                latestLocation = nil

                switch error {

                        // we do Dispatch to main queue in updateWithAnimation()
                    case .locationServicesNotEnabled:
                        appState.updateWithAnimation(to: .errorGettingLocation(LuasStrings.locationServicesDisabled))

                    case .locationAccessDenied:
                        appState.updateWithAnimation(to: .errorGettingLocation(LuasStrings.locationAccessDenied))

                    case .locationManagerError(let error):
                        appState.updateWithAnimation(to: .errorGettingLocation(error.localizedDescription))

                    case .authStatus(let authStatusError):
                        if let errorMessage = authStatusError.localizedErrorMessage() {
                            appState.updateWithAnimation(to: .errorGettingLocation(LuasStrings.gettingLocationAuthError(errorMessage)))
                        } else {
                            appState.updateWithAnimation(to: .errorGettingLocation(LuasStrings.gettingLocationOtherError))
                        }
                }

            } catch {
                // generic error
                appState.updateWithAnimation(to: .errorGettingLocation(LuasStrings.gettingLocationOtherError))
            }
        }
    }

}

extension Coordinator {

    internal func handle(_ closestStation: TrainStation,
                         _ location: CLLocation) {
        // use different states with self.trains: if we have previously loaded a list of trains, let's preserve it in the UI while loading

        if let trains = self.trains {
            appState.updateWithAnimation(to: .updatingDueTimes(trains, location))
        } else {
            appState.updateWithAnimation(to: .gettingDueTimes(closestStation, location))
        }

        Task {

            do {
                let trains = try await api.dueTimes(for: closestStation)

                DispatchQueue.main.async { [weak self] in

                    print("\(#function): got trains \(trains)")
                    self?.trains = trains
                    self?.appState.updateWithAnimation(to: .foundDueTimes(trains, location))
                }

            } catch {

                trains = nil
                print("\(#function):  caught error \(error.localizedDescription)")

                DispatchQueue.main.async { [weak self] in

                    if let apiError = error as? APIError {

                        switch apiError {
                            case .noTrains(let message):
                                self?.appState.updateWithAnimation(to:
                                        .errorGettingDueTimes(closestStation,
                                                              message.count > 0 ? message : LuasStrings.errorGettingDueTimes))

                            case .invalidXML:
                                self?.appState.updateWithAnimation(
                                    to: .errorGettingDueTimes(closestStation, "Error reading server response"))
                        }
                    } else {
                        self?.appState.updateWithAnimation(to:
                                .errorGettingDueTimes(closestStation, LuasStrings.errorGettingDueTimes))
                    }
                }
            }
        }
    }
}
