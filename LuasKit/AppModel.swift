//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftUI

// @Observable does not work -  circular reference?
public class AppModel: ObservableObject {

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

    #if DEBUG
        // so we can simulate app state in a sequence
        public let mockMode = false
    #endif

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
