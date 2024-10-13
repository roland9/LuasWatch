//
//  Created by Roland Gropmair on 23/10/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

@main
struct LuasWatchiOSApp: App {
  @Environment(\.scenePhase) var scenePhase

  let appState = AppState()
  let location = Location()
  var mainCoordinator: Coordinator!

  init() {
    mainCoordinator = Coordinator(appState: appState, location: location)
    appState.changeable = mainCoordinator
    mainCoordinator.start()
  }

  var body: some Scene {
    WindowGroup {
      LuasView()
        .environmentObject(appState)
    }
    .onChange(of: scenePhase) {
      switch $0 {
      case .background, .inactive:
        mainCoordinator.invalidateTimer()

      case .active:
        mainCoordinator.scheduleTimer()

      @unknown default:
        break
      }
    }

  }
}
