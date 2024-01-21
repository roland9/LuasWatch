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

            myPrint("need location for current appMode \(appModel.appMode) -> prompt for location auth")
            location.promptLocationAuth()

        } else {
            myPrint("no location needed for the current appMode \(appModel.appMode)")
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
        #warning("check whether modal is up")

        // if user has selected a specific station
        if let station = appModel.appMode.specificStation {

            // the location we have is not too old -> don't wait for another location update
            if let latestLocation = appModel.latestLocation,
                latestLocation.isQuiteRecent()
            {
                myPrint("🥳 we have user selected station & recent location -> skip location update")
                handle(station, latestLocation)
            } else {
                myPrint(
                    "😇 user has selected specific station & only outdated or no location \(appModel.latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update"
                )
                location.update()
            }

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
