//
//  Created by Roland Gropmair on 23/10/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import SwiftData
import OSLog

import LuasAPI
import LuasApp

@main
struct LuasWatchiOSApp: App {
  @Environment(\.scenePhase) var scenePhase

  let logger = Logger(subsystem: "LuasWatchiOS", category: "LuasWatchiOSApp")

  private var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      FavouriteStation.self,
      StationDirection.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

      // WIP create sample data

      return container
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  let appModel = AppModel()
  let location = Location()
  var mainCoordinator: Coordinator!

  init() {
    mainCoordinator = Coordinator(
      appModel: appModel,
      location: location)

    mainCoordinator.start()
  }

  var body: some Scene {
    WindowGroup {
      LuasMainScreen()
    }
    .environmentObject(appModel)
    .modelContainer(sharedModelContainer)

    .onChange(of: scenePhase) {
      switch $0 {
      case .background, .inactive:
          logger.info("App did enter background or because inactive -> invalidateTimer")
          mainCoordinator.invalidateTimer()

      case .active:
          logger.info("App became active -> fireAndScheduleTimer")

          mainCoordinator.fireAndScheduleTimer()

      @unknown default:
        break
      }
    }
  }
}
