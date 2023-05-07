//
//  Created by Roland Gropmair on 09/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKitIOS

@main
struct LuasWatchiOSApp: App {
    @Environment(\.scenePhase) var scenePhase

    let coordinator: Coordinator = {
        let appState = AppState()
        let location = Location()

        let coord = Coordinator(appState: appState, location: location)
        coord.start()

        return coord
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in

            switch phase {
                case .background:
                    coordinator.invalidateTimer()
                case .inactive:
                    break
                case .active:
                    coordinator.scheduleTimer()
                @unknown default:
                    break
            }
        }
    }
}
