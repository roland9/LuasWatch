//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Combine
import Foundation
import LuasKit

class Coordinator: NSObject {

    internal let appModel: AppModel
    internal var location: Location
    internal var trains: TrainsByDirection?
    internal let api = LuasAPI(apiWorker: RealAPIWorker())

    private var timer: Timer?
    private static let refreshInterval = 12.0
    private var cancellable: AnyCancellable?

    init(
        appModel: AppModel,
        location: Location
    ) {
        self.appModel = appModel
        self.location = location
        self.cancellable = appModel.$appState
            .sink { newAppState in
                if case .gettingLocation = newAppState {
                    location.promptLocationAuth()
                }
            }
    }

    deinit {
        // do we need to do that manually?
        cancellable?.cancel()
    }

    func start() {

        // //////////////////////////////////////////////
        // step 1: if required, determine location
        location.delegate = self

        if appModel.appMode.needsLocation {

            myPrint("need location auth for current appMode \(appModel.appMode) -> prompt for location auth")
            location.promptLocationAuth()

        } else {
            myPrint("no location auth needed for the current appMode \(appModel.appMode)")
        }

        /// we will call location.start() once user has authorized location access

        #warning("a bit ugly -  notification is sent by ChangeStationButton - is there a better way?")
        NotificationCenter.default.addObserver(
            forName: Notification.Name("LuasWatch.RetriggerTimer"),
            object: nil, queue: nil
        ) { _ in
            self.retriggerTimer()
        }
    }

    func invalidateTimer() {
        timer?.invalidate()
    }

    func retriggerTimer() {
        myPrint(#function)

        timer?.invalidate()

        // when we tap a station in sidebarView and force a retrigger, it's still up & we would ignore it -> let's override this check
        appModel.allowStationTabviewUpdates = true

        fireAndScheduleTimer()
    }

    internal func fireAndScheduleTimer() {
        // fire right now...
        timerDidFire()

        // ... and then schedule again for regular interval
        timer = Timer.scheduledTimer(
            timeInterval: Self.refreshInterval,
            target: self, selector: #selector(timerDidFire),
            userInfo: nil, repeats: true)
    }

    @objc func timerDidFire() {
        myPrint("😇 \(#function)")

        guard appModel.allowStationTabviewUpdates == true else {
            myPrint("😇 SidebarView is up -> ignore timer firing so we don't interfere UI")
            return
        }

        if let station = appModel.appMode.specificStation {

            // if user has selected a specific station
            myPrint("🥳 user selected station -> skip location update")
            handle(station)

        } else {
            // user has NOT selected a specific station

            if let latestLocation = appModel.latestLocation,
                latestLocation.isQuiteRecent()
            {
                // we have a location that's not too old
                myPrint("🥳 user has NOT selected specific station & we have a recent location -> skip location update")
                didGetLocation(latestLocation)
            } else {
                myPrint(
                    "😇 user has NOT selected specific station & only outdated location \(appModel.latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update"
                )
                location.update()
            }
        }
    }
}
