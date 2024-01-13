//
//  Created by Roland Gropmair on 13/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import CoreLocation
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
        location.start()
    }

    func didGetLocation(_ location: CLLocation) {

        appModel.latestLocation = location

        // //////////////////////////////////////////////
        // step 2: we have location -> now find station
        let allStations = TrainStations.sharedFromFile


        if let station = appModel.appMode.specificStation {
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

    internal func handle(_ closestStation: TrainStation,
                         _ location: CLLocation) {
        // use different states: if we have previously loaded a list of trains, let's preserve it in the UI while loading

        // sometimes crash on watchOS 9
        // [SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            if let trains = self.trains {
                appModel.updateWithAnimation(to: .updatingDueTimes(trains, location))
            } else {
                appModel.updateWithAnimation(to: .loadingDueTimes(closestStation, location))
            }

        // //////////////////////////////////////////////
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
