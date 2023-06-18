//
//  Created by Roland Gropmair on 17/06/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

public class LocationHandler: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var locationUpdateCompletion: ((Result<CLLocation, Error>) -> Void)?

    public override init() {
        super.init()
        locationManager.delegate = self
    }

    public func requestLocation() async throws -> CLLocation {

        guard CLLocationManager.locationServicesEnabled() else {
            print("\(#function): services NOT enabled")
            throw LocationDelegateError.locationServicesNotEnabled
        }

        // WIP shouldn't be called always?   use locationManager(_:didChangeAuthorization:)
#warning("test: fresh app install, it hangs after you allowed location update!")
        locationManager.requestWhenInUseAuthorization()

        let location = try await withCheckedThrowingContinuation { continuation in
            self.locationUpdateCompletion = { result in

                switch result {

                    case .success(let location):
                        print("\(#function): got location")
                        continuation.resume(returning: location)

                    case .failure(let error):
                        print("\(#function): failed to get location with error \(error)")
                        continuation.resume(throwing: error)
                }

                self.locationUpdateCompletion = nil
            }

            locationManager.requestLocation()
        }

        return location
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateCompletion?(.success(location))
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationUpdateCompletion?(.failure(error))
    }
}
