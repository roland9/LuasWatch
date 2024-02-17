//
//  Created by Roland Gropmair on 13/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation
import LuasKit

extension Coordinator: LocationDelegate {

    func didFail(_ delegateError: LocationDelegateError) {

        appModel.latestLocation = nil

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
        #if DEBUG
            if isRunningUnitTests() { return }
        #endif

        if appModel.appMode.needsLocation {
            location.start()
        } else {
            myPrint("no location auth needed for the current appMode \(appModel.appMode)")
        }
    }

    func didGetLocation(_ location: CLLocation) {

        appModel.latestLocation = location

        // //////////////////////////////////////////////
        // step 2: we have location -> now find station
        let allStations = TrainStations.sharedFromFile

        if let station = appModel.appMode.specificStation {
            myPrint("step 2a: got location now, but user selected specific station before -> use this station now")
            handle(station)

        } else {
            myPrint("step 2b: got location; find closest station (no matter which line)")

            if let closestStation = allStations.closestStation(from: location) {

                if appModel.appMode == .closest {
                    myPrint("found closest station <\(closestStation.name)>")
                    handle(closestStation)
                } else if appModel.appMode == .closestOtherLine,
                    let closestOtherLine = allStations.closestStation(from: location, route: closestStation.route.other)
                {
                    myPrint("found closest other line station <\(closestOtherLine.name)>")
                    handle(closestOtherLine)
                } else {
                    assertionFailure("internal error")
                    // this should not happen unless we missed an appMode case;  as fallback let's use the closestStation
                    myPrint("found closest station <\(closestStation.name)>")
                    handle(closestStation)
                }

            } else {
                myPrint("step 2c: no station found -> user too far away")
                appModel.updateWithAnimation(to: .errorGettingStation(LuasStrings.tooFarAway))
            }
        }
    }

    internal func handle(
        _ closestStation: TrainStation
    ) {
        #warning("WIP use different states: if we have previously loaded a list of trains, let's preserve it in the UI while loading")

        appModel.selectedStation = closestStation

        if let cachedTrains = previouslyLoadedTrains,
            cachedTrains.for.name == closestStation.name
        {
            /// only use the cached trains list if they actually match the station we're about to load
            /// (otherwise the UI looks wrong, e.g. might show the incorrect line color
            appModel.updateWithAnimation(
                to: .loadingDueTimes(
                    closestStation,
                    cachedTrains.trains))
        } else {
            appModel.updateWithAnimation(to: .loadingDueTimes(closestStation, nil))
        }

        // //////////////////////////////////////////////
        // step 3: get due times from API
        Task {

            do {

                myPrint("calling API for station \(closestStation.name) ...")
                let trains = try await self.api.dueTimes(for: closestStation)
                myPrint("... got trains \(trains)")

                previouslyLoadedTrains = (for: closestStation, trains: trains)

                appModel.updateWithAnimation(to: .foundDueTimes(trains))

            } catch {

                myPrint("caught error \(error.localizedDescription)")

                previouslyLoadedTrains = nil

                if let apiError = error as? APIError {

                    switch apiError {
                        case .noTrains(let message):
                            appModel.updateWithAnimation(
                                to:
                                    .errorGettingDueTimes(
                                        closestStation,
                                        message.count > 0 ? message : LuasStrings.errorGettingDueTimes))

                        case .invalidXML:
                            appModel.updateWithAnimation(
                                to: .errorGettingDueTimes(closestStation, "Error reading server response"))
                    }
                } else {
                    appModel.updateWithAnimation(
                        to:
                            .errorGettingDueTimes(closestStation, LuasStrings.errorGettingDueTimes))
                }
            }
        }
    }
}
