//
//  Created by Roland Gropmair on 18/06/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation
import LuasKit

extension Coordinator {

    internal static let refreshInterval = 12.0

    func scheduleTimer() {
        // fire right now...
        timerDidFire()

        // ... but also schedule for later
        timer = Timer.scheduledTimer(timeInterval: Self.refreshInterval,
                                     target: self, selector: #selector(timerDidFire),
                                     userInfo: nil, repeats: true)
    }

    func retriggerTimer() {
        timer?.invalidate()

        // fire right now...
        timerDidFire()

        // ... and then schedule again for regular interval
        timer = Timer.scheduledTimer(timeInterval: Self.refreshInterval,
                                     target: self, selector: #selector(timerDidFire),
                                     userInfo: nil, repeats: true)
    }

    func invalidateTimer() {
        timer?.invalidate()
    }

    @objc func timerDidFire() {

        guard appState.isStationsModalPresented == false else {
            print("💔 StationsModal is up (isStationsModalPresented == true) -> ignore location update timer")
            return
        }

        // if user has selected a specific station & the location we have is not too old -> don't wait  for another location update
        if let station = MyUserDefaults.userSelectedSpecificStation(),
           let latestLocation = latestLocation,
           latestLocation.timestamp.timeIntervalSinceNow < -25.0 {
            print("🥳 we have user selected station & recent location -> skip location update")
            handle(station, latestLocation)
        } else {
            // user has NOT selected a specific station;  or the location we have it quite outdated -> wait for new location update
            print("😇 only outdated location \(latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update")
//            location.update()
        }
    }
}
