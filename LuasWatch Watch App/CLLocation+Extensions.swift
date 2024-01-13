//
//  Created by Roland Gropmair on 13/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation

extension CLLocation {

    func isQuiteRecent() -> Bool {
        timestamp.timeIntervalSinceNow > -20.0
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
