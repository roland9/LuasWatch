//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftUI

// @Observable does not work -  circular reference?
public class AppModel: ObservableObject {

    /// state machine, drives UI
    public enum AppState {

        case idle

        case gettingLocation
        case locationAuthorizationUnknown
        case errorGettingLocation(String)

        /// when user is too far away from Dublin area
        case errorGettingStationTooFarAway(String)

        case loadingDueTimes(TrainStation, TrainsByDirection?)
        case errorGettingDueTimes(TrainStation, String)

        case foundDueTimes(TrainsByDirection)

        public init(_ state: AppState) {
            self = state
        }
    }

    /// how user decided how current station should be determined
    public enum AppMode: Equatable {

        /// need location
        case closest
        case closestOtherLine

        /// no location required, because user selected specific station (via various options)
        case favourite(TrainStation)
        case nearby(TrainStation)
        case specific(TrainStation)
        case recents(TrainStation)

        public var specificStation: TrainStation? {
            switch self {

                case .closest, .closestOtherLine:
                    return nil
                case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                    return station
            }
        }

        public var needsLocation: Bool {
            self == .closest || self == .closestOtherLine
        }
    }

    @Published public var appState: AppState = .idle

    @Published public var appMode: AppMode = .closest {
        didSet {
            do {
                let encoded = try JSONEncoder().encode(appMode)
                UserDefaults.standard.set(encoded, forKey: "AppMode")

                switch appMode {

                    case .closest, .closestOtherLine:
                        self.selectedStation = nil
                    case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                        self.selectedStation = station
                }
                NotificationCenter.default.post(Notification(name: Notification.Name("LuasWatch.RetriggerTimer")))

            } catch {
                myPrint("error encoding appMode \(error)")
            }
        }
    }

    // WIP do we need both - appMode & selectedStation??
    // don't need to save here, because we also set the appMode above - which gets saved
    // in fact, ideally we could get rid of the selectedStation - because it's part of the appMode??!!
    @Published public var selectedStation: TrainStation?

    @Published public var latestLocation: CLLocation?

    @Published public var allowStationTabviewUpdates: Bool = true

    @Published public var locationDenied: Bool = false

    public init() {
        if let storedAppModeData = UserDefaults.standard.object(forKey: "AppMode") as? Data,
            let storedAppMode = try? JSONDecoder().decode(AppMode.self, from: storedAppModeData)
        {
            self.appMode = storedAppMode

            switch storedAppMode {

                case .closest, .closestOtherLine:
                    self.selectedStation = nil
                case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                    self.selectedStation = station
            // we don't need to trigger here do we?
            //                    NotificationCenter.default.post(Notification(name: Notification.Name("LuasWatch.RetriggerTimer")))
            }

        } else {
            self.appMode = .closest
            self.selectedStation = nil
        }
    }

    // for previews
    public init(_ state: AppState) {
        self.appState = state
    }
}
