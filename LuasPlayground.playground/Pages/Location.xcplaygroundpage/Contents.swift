import CoreLocation
import LuasKitIOS

let locationHandler = LocationHandler()

do {
    let location = try await locationHandler.requestLocation()
    // Handle location update
    print(location)
} catch let error as LocationDelegateError {
    // Handle location service unavailable error
    print("LocationDelegateError error \(error)")
} catch {
    // Handle other errors
    print("Other error \(error.localizedDescription)")
}
