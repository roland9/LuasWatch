//
//  Created by Roland Gropmair on 07/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKitIOS

class Coordinator: NSObject {

    private let api = LuasAPI(apiWorker: RealAPIWorker())

    private let appState: AppState
    private var location: Location
    private var timer: Timer?

    private var latestLocation: CLLocation?

    private var trains: TrainsByDirection?

    static let refreshInterval = 12.0

    init(appState: AppState,
         location: Location) {
        self.appState = appState
        self.location = location
    }

    func start() {

        //////////////////////////////////
        // step 1: determine location
        location.delegate = self

        location.start()

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
            print("💔 StationsModal is up (isStationsModalPresented == true) -> ignore location update timer")
            return
        }

        // if user has selected a specific station & the location we have is not too old -> don't wait  for another location update
        if let station = MyUserDefaults.userSelectedSpecificStation(),
           let latestLocation = latestLocation,
           latestLocation.timestamp.timeIntervalSinceNow < -25.0 {
            print("🥳 we have user selected station & recent location -> skip location update")
            handle(station, latestLocation)
        } else {
            // user has NOT selected a specific station;  or the location we have it quite outdated -> wait for new location update
            print("😇 only outdated location \(latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update")
            location.update()
        }
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

    fileprivate func handle(_ closestStation: TrainStation,
                            _ location: CLLocation) {
        // use different states: if we have previously loaded a list of trains, let's preserve it in the UI while loading

        // sometimes crash on watchOS 9
        // [SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

        if let trains = self.trains {
            self.appState.state = .updatingDueTimes(trains, location)
        } else {
            self.appState.state = .gettingDueTimes(closestStation, location)
        }

        //////////////////////////////////
        // step 3: get due times from API
        Task {

            do {
                let trains = try await api.dueTimes(for: closestStation)

                DispatchQueue.main.async { [weak self] in

                    print("\(#function): got trains \(trains)")
                    self?.trains = trains
                    self?.appState.state = .foundDueTimes(trains, location)
                }

            } catch {

                trains = nil
                print("\(#function):  caught error \(error.localizedDescription)")

                DispatchQueue.main.async { [weak self] in

                    if let apiError = error as? APIError {

                        switch apiError {
                            case .noTrains(let message):
                                self?.appState.state =
                                    .errorGettingDueTimes(closestStation,
                                                          message.count > 0 ? message : LuasStrings.errorGettingDueTimes)

                            case .invalidXML:
                                self?.appState.state =
                                    .errorGettingDueTimes(closestStation, "Error reading server response")
                        }
                    } else {
                        self?.appState.state =
                            .errorGettingDueTimes(closestStation, LuasStrings.errorGettingDueTimes)
                    }
                }
            }
        }
    }
}
