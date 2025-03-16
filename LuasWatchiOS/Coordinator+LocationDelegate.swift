//
//  Created by Roland Gropmair on 13/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasAPI
import LuasApp

extension Coordinator: LocationDelegate {

  func didFail(_ delegateError: LocationDelegateError) {
    logger.error("error \(delegateError)")

    appModel.latestLocation = nil

    switch delegateError {

    case .locationServicesNotEnabled:
      appModel.locationDenied = true

      updateWithAnimation(to: .errorGettingLocation(LuasStrings.locationServicesDisabled))

    case .locationAccessDenied:
      appModel.locationDenied = true

      // that does not show up -> do I need to set appModel.selectedStation =
      updateWithAnimation(to: .errorGettingLocation(LuasStrings.locationAccessDenied))

    case .locationManagerError(let error):
      updateWithAnimation(to: .errorGettingLocation(error.localizedDescription))
    }
  }

  func didEnableLocation() {
    appModel.locationDenied = false

    #if DEBUG
//      if isRunningUnitTests() { return }
    #endif

    if appModel.appMode.needsLocation {
      location.start()
    } else {
      logger.debug("no location auth needed for the current appMode \(self.appModel.appMode)")
    }
  }

  func didGetLocation(_ location: CLLocation) {

    appModel.locationDenied = false
    appModel.latestLocation = location

    // //////////////////////////////////////////////
    // step 2: we have location -> now find station
    let allStations = TrainStations()

    if let station = appModel.appMode.specificStation {
      logger.debug(
        "step 2a: got location now, but user selected specific station before -> use this station now"
      )
      handle(station)

    } else {
      logger.debug("step 2b: got location; find closest station (no matter which line)")

      if let closestStation = allStations.closestStation(from: location) {

        if appModel.appMode == .closest {
          logger.debug("found closest station <\(closestStation.name)>")
          handle(closestStation)
        } else if appModel.appMode == .closestOtherLine,
          let closestOtherLine = allStations.closestStation(
            from: location, route: closestStation.route.other)
        {
          logger.debug("found closest other line station <\(closestOtherLine.name)>")
          handle(closestOtherLine)
        } else {
          assertionFailure("internal error")
          // this should not happen unless we missed an appMode case;  as fallback let's use the closestStation
          logger.debug("found closest station <\(closestStation.name)>")
          handle(closestStation)
        }

      } else {
        logger.debug("step 2c: no station found -> user too far away")

        guard appModel.allowStationTabviewUpdates == true else {
          logger.debug("SidebarView is up -> ignore new location so we don't interfere UI")
          return
        }

        updateWithAnimation(to: .errorGettingStationTooFarAway(LuasStrings.tooFarAway))
      }
    }
  }

  internal func handle(
    _ closestStation: TrainStation
  ) {
    appModel.selectedStation = closestStation

    if appModel.allowStationTabviewUpdates {
      if let cachedTrains = previouslyLoadedTrains,
        cachedTrains.for.name == closestStation.name
      {
        /// only use the cached trains list if they actually match the station we're about to load
        /// (otherwise the UI looks wrong, e.g. might show the incorrect line color

        /// DON'T use updateWithAnimation() here, at first launch it shows empty content?!?
        appModel.appState = .loadingDueTimes(
          closestStation, cachedTrains: cachedTrains.trains)
      } else {

        /// DON'T use updateWithAnimation() here, at first launch it shows empty content?!?
        appModel.appState = .loadingDueTimes(
          closestStation, cachedTrains: nil)
      }
    } else {
      logger.debug("SidebarView is up -> ignore so we don't interfere UI")
    }

    // //////////////////////////////////////////////
    // step 3: get due times from API
    Task {

      do {

        logger.debug("calling API for station \(closestStation.name) ...")

        let trains = try await self.api.dueTimes(for: closestStation)

        logger.debug("... got trains \(String(describing: trains))")

        previouslyLoadedTrains = (for: closestStation, trains: trains)
        if appModel.allowStationTabviewUpdates {
          updateWithAnimation(to: .foundDueTimes(trains))
        } else {
          logger.debug("SidebarView is up -> ignore so we don't interfere UI")
        }

      } catch {

        logger.error("...caught error \(error.localizedDescription)")

        previouslyLoadedTrains = nil

        guard appModel.allowStationTabviewUpdates else {
          logger.debug("SidebarView is up -> ignore so we don't interfere UI")
          return
        }

        if let apiError = error as? APIError {

          switch apiError {
            case .noTrainsButMessageFromAPI(let message):
              updateWithAnimation(to:
                  .errorGettingDueTimes(
                    closestStation,
                    message))

            case .noTrains:
              updateWithAnimation(to:
                  .errorGettingDueTimes(
                    closestStation,
                    LuasStrings.noTrainsErrorMessage))

            case .invalidXML:
              updateWithAnimation(
                to: .errorGettingDueTimes(closestStation, "Error reading server response"))
          }

        } else if (error as NSError).code == NSURLErrorNotConnectedToInternet {
          updateWithAnimation(
            to: .errorGettingDueTimes(
              closestStation,
              LuasStrings.errorNoInternet))
        } else {
          updateWithAnimation(
            to: .errorGettingDueTimes(
              closestStation,
              LuasStrings.errorGettingDueTimes(station: closestStation.name)))
        }
      }
    }
  }
}
