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
  internal let api = LuasAPI(apiWorker: RealAPIWorker())

  private var timer: Timer?
  private static let refreshInterval = 12.0
  private var cancellable: AnyCancellable?

  internal var previouslyLoadedTrains:
    (for: TrainStation, trains: TrainsByDirection)?

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
    // WIP do we actually need to do that manually?
    cancellable?.cancel()
  }

  func start() {

    #if DEBUG
      if appModel.mockMode == true {
        // force specific app flow for debugging and taking screenshots

        appModel.appState = .foundDueTimes(trainsGreen)

        // testing: switch to another state with delay
        //        appModel.appState = .gettingLocation
        //
        //        executeAfterDelay { [weak self] in
        //          self?.appModel.appState = .errorGettingLocation("error getting location")
        //
        //          self?.executeAfterDelay {
        //            self?.appModel.appState = .locationAuthorizationUnknown
        //          }
        //        }
        return
      }
    #endif

    // //////////////////////////////////////////////
    // step 1: if required, determine location
    location.delegate = self

    if appModel.appMode.needsLocation {

      myPrint(
        "need location auth for current appMode \(appModel.appMode) -> prompt for location auth"
      )
      location.promptLocationAuth()
      /// we will call location.start() once user has authorized location access

    } else {
      myPrint(
        "no location auth needed for the current appMode \(appModel.appMode)")

      /// don't call handle here -> because  when app goes to active`fireAndScheduleTimer` will be called by changing of the scenePhase

      //    guard let specificStation = appModel.appMode.specificStation else {
      //        assertionFailure("internal error")
      //        myPrint("🚨 internal error: expected specific station in appModel")
      //        return
      //    }
      //    handle(specificStation)
    }

    #warning("notification is sent by appMode.didSet - is there a better way?")
    NotificationCenter.default.addObserver(
      forName: Notification.Name("LuasWatch.RetriggerTimer"),
      object: nil, queue: nil
    ) { _ in
      self.fireAndScheduleTimer()
    }
  }

  func invalidateTimer() {
    timer?.invalidate()
  }

  func fireAndScheduleTimer() {
    myPrint(#function)

    invalidateTimer()

    /// when we tap a station in sidebarView and force a retrigger, it's still up & we would ignore it -> let's override this check
    appModel.allowStationTabviewUpdates = true

    // fire and schedule
    timerDidFire()
    scheduleTimer()
  }

  // schedule timer for regular interval
  internal func scheduleTimer() {
    myPrint("\(#function)")

    timer = Timer.scheduledTimer(
      timeInterval: Self.refreshInterval,
      target: self, selector: #selector(timerDidFire),
      userInfo: nil, repeats: true)
  }

  @objc func timerDidFire() {
    myPrint("\(#function)")

    guard appModel.allowStationTabviewUpdates == true else {
      myPrint(
        "SidebarView is up -> ignore timer firing so we don't interfere UI")
      return
    }

    if let station = appModel.appMode.specificStation {

      myPrint("User selected station -> skip location update")
      handle(station)

    } else {

      // User has NOT selected a specific station

      if let latestLocation = appModel.latestLocation,
        latestLocation.isQuiteRecent()
      {
        myPrint(
          "User has NOT selected specific station & we have a recent location -> skip location update"
        )
        didGetLocation(latestLocation)
      } else {
        myPrint(
          "User has NOT selected specific station & only outdated location \(appModel.latestLocation?.timestamp.timeIntervalSinceNow ?? 0) -> wait for location update"
        )
        location.update()
      }
    }
  }

  #if DEBUG
    private func executeAfterDelay(_ block: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        block()
      }
    }
  #endif
}
