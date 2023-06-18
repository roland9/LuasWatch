//
//  Created by Roland Gropmair on 18/06/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

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
