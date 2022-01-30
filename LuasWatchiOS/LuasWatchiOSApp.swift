//  Created by Roland Gropmair on 30/01/2022.
//  Copyright © 2022 mApps.ie. All rights reserved.

import SwiftUI
import LuasKitIOS

@main
struct LuasWatchiOSApp: App {

	let appState = AppState()
	let location = Location()
	var mainCoordinator: Coordinator!

	init() {
		mainCoordinator = Coordinator(appState: appState, location: location)
		mainCoordinator.start()
	}

    var body: some Scene {
        WindowGroup {
            LuasView()
				.environmentObject(appState)
				.onAppear {
					// WIP test whether that's only called one??
					mainCoordinator.scheduleTimer()
				}
				.onDisappear {
					mainCoordinator.invalidateTimer()
				}
        }
    }
}
