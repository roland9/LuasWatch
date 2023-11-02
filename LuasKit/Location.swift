//
//  Created by Roland Gropmair on 05/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation

public protocol LocationDelegate: AnyObject {
	func didFail(_ error: LocationDelegateError)
    func didEnableLocation()
	func didGetLocation(_ location: CLLocation)
}

public enum LocationDelegateError: Error {
	case locationServicesNotEnabled
	case locationAccessDenied
	case locationManagerError(Error)
	case authStatus(CLAuthorizationStatus)
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

	public override init() {
        super.init()
        locationManager.delegate = self
    }

    public func promptLocationAuth() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }

    // start getting location
    public func start() {
        myPrint("startUpdatingLocation")
        internalState = .gettingLocation
        locationManager.startUpdatingLocation()
	}

    #warning("that will be called very shortly after start because timer fires & calls update")
    
	public func update() {
        if locationAuthState == .granted &&
            (internalState == .stoppedUpdatingLocation || internalState == .error) {
            myPrint("startUpdatingLocation")

            internalState = .gettingLocation
            locationManager.startUpdatingLocation()
        }
	}
}

extension Location: CLLocationManagerDelegate {

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		myPrint("\(error)")

		internalState = .error
		let nsError = error as NSError

		if nsError.domain == kCLErrorDomain &&
			nsError.code == CLError.Code.denied.rawValue {
			delegate?.didFail(.locationAccessDenied)
		} else if nsError.domain == kCLErrorDomain &&
			nsError.code == CLError.Code.locationUnknown.rawValue {
		} else {
			delegate?.didFail(.locationManagerError(error))
		}
	}

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        myPrint("\(manager.authorizationStatus.description)")

		switch manager.authorizationStatus {
            case .notDetermined:
                break
			case .denied, .restricted:
                locationAuthState = .denied
				delegate?.didFail(.authStatus(manager.authorizationStatus))
			case .authorizedAlways, .authorizedWhenInUse:
                locationAuthState = .granted
                delegate?.didEnableLocation()
			@unknown default:
				myPrint("default")
		}
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		myPrint("\(locations)")

		let lastLocation = locations.last!

		// TODOLATER If it's a relatively recent event, turn off updates to save power. Also, turn on again later

		let howRecent = lastLocation.timestamp.timeIntervalSinceNow

		if abs(howRecent) < 15.0 {

            // we should kill previous API requests if there is a newer location
			delegate?.didGetLocation(lastLocation)

			if lastLocation.horizontalAccuracy < 100 &&
				lastLocation.verticalAccuracy < 100 {
				myPrint("last location quite precise -> stopping location updates for now")

				internalState = .stoppedUpdatingLocation
				locationManager.stopUpdatingLocation()
			}

		} else {
			myPrint("ignoring lastLocation because too old (\(howRecent) seconds ago")
		}
	}

}

extension CLAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch self {
             case .notDetermined:
                 return "Not Determined"
             case .restricted:
                 return "Restricted"
             case .denied:
                 return "Denied"
             case .authorizedAlways:
                 return "Authorized Always"
             case .authorizedWhenInUse:
                 return "Authorized When In Use"
             @unknown default:
                 return "Unknown"
        }
    }
}
