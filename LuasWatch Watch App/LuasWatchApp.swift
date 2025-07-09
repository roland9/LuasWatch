//
//  Created by Roland Gropmair on 13/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftData
import SwiftUI
import OSLog

import LuasAPI
import LuasApp

@main
struct LuasWatch_Watch_App: App {

  let logger = Logger(subsystem: "LuasWatch", category: "LuasWatch_Watch_App")

  @Environment(\.scenePhase) var scenePhase

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

  private let appModel = AppModel()
  private let location = Location()
  private var mainCoordinator: Coordinator!

  init() {
    mainCoordinator = Coordinator(
      appModel: appModel,
      location: location)

    #if DEBUG
      if isRunningUnitTests() { return }
    #endif

    mainCoordinator.start()
  }

  var body: some Scene {

    WindowGroup {
      LuasMainScreen()
    }
    .environmentObject(appModel)
    .modelContainer(sharedModelContainer)

    .onChange(of: scenePhase) {
      switch scenePhase {
      case .background, .inactive:
        logger.info("App did enter background or because inactive -> invalidateTimer")
        mainCoordinator.invalidateTimer()

      case .active:
        logger.info("App became active -> fireAndScheduleTimer")

        #if DEBUG
          if appModel.mockMode == true {
            return
          }
        #endif

        mainCoordinator.fireAndScheduleTimer()

      @unknown default:
        break
      }
    }
  }
}
