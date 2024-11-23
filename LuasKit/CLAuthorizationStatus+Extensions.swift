//
//  Created by Roland Gropmair on 17/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation

extension CLAuthorizationStatus {

  public var readableDescription: String {
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
