//
//  Created by Roland Gropmair on 13/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

@main
struct LuasWatch_Watch_AppApp: App {

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
                    myPrint("App did enter background or because inactive -> invalidateTimer")
                    mainCoordinator.invalidateTimer()

                case .active:
                    myPrint("App became active -> fireAndScheduleTimer")
                    mainCoordinator.fireAndScheduleTimer()

                @unknown default:
                    break
            }
        }
    }
}
