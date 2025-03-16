//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import OSLog

import LuasAPI

public protocol LocationDelegate: AnyObject {
  func didFail(_ error: LocationDelegateError)
  func didEnableLocation()
  func didGetLocation(_ location: CLLocation)
}

public enum LocationDelegateError: Error {
  case locationServicesNotEnabled
  case locationAccessDenied
  case locationManagerError(Error)
}

enum InternalState {
  case initializing, gettingLocation, stoppedUpdatingLocation, error
}

enum LocationAuthState {
  case unknown, granted, denied
}

public class Location: NSObject {

  public weak var delegate: LocationDelegate?

  var locationAuthState: LocationAuthState = .unknown
  var internalState: InternalState = .initializing

  let locationManager = CLLocationManager()

  let logger = Logger(subsystem: "LuasApp", category: "Location")

  public func promptLocationAuth() {
    logger.info(#function)
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }

  /// start getting location
  public func start() {
    logger.info("calling locationManager.startUpdatingLocation")

    internalState = .gettingLocation
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
  }

  public func update() {
    if (locationAuthState == .granted
      && (internalState == .stoppedUpdatingLocation || internalState == .error))
      || internalState == .initializing
      || locationAuthState == .unknown
    {

      logger.info("\(String(describing: self.locationAuthState)) \(String(describing: self.internalState)) -> calling locationManager.startUpdatingLocation")

      internalState = .gettingLocation
      locationManager.delegate = self
      locationManager.startUpdatingLocation()

    } else if locationAuthState == .denied {
      logger.info("\(String(describing: self.locationAuthState)) \(String(describing: self.internalState)) -> calling delegate didFail(.denied)")

      delegate?.didFail(.locationAccessDenied)

    } else {
      assertionFailure("internal error")
      logger.error("🚨 NOT calling locationManager.startUpdatingLocation")
    }
  }
}

extension Location: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    logger.error("\(error)")

    internalState = .error
    let nsError = error as NSError

    if nsError.domain == kCLErrorDomain && nsError.code == CLError.Code.denied.rawValue {
      logger.error("didFail .locationAccessDenied")
      delegate?.didFail(.locationAccessDenied)

    } else {
      logger.error("didFail .locationManagerError")
      delegate?.didFail(.locationManagerError(error))
    }
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    logger.info("authorizationStatus: \(manager.authorizationStatus.readableDescription)")

    switch manager.authorizationStatus {
    case .notDetermined:
      break
    case .denied, .restricted:
      locationAuthState = .denied
      delegate?.didFail(.locationAccessDenied)
    case .authorizedAlways, .authorizedWhenInUse:
      locationAuthState = .granted
      delegate?.didEnableLocation()
    @unknown default:
        logger.info("default")
    }
  }

  public func locationManager(
    _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
  ) {
    logger.info("\(locations)")

    guard let lastLocation = locations.last else {
      assertionFailure("internal error")
      logger.error("🚨 internal error: expected a location in the locations array")
      return
    }

    let howRecent = lastLocation.timestamp.timeIntervalSinceNow

    if abs(howRecent) < 15.0 {

      if lastLocation.horizontalAccuracy < 100 && lastLocation.verticalAccuracy < 100 {
        logger.debug("last location quite precise -> stopping location updates for now")

        internalState = .stoppedUpdatingLocation
        /// it seems that calling stopUpdatingLocation() does still deliver sometimes 3 location updates, which causes superfluous API calls....
        /// setting the delegate to nil avoids that (but need to remember to set it to self again!)
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
      }

      delegate?.didGetLocation(lastLocation)

    } else {
      logger.info("ignoring lastLocation because too old (\(howRecent) seconds ago")
    }
  }
}
