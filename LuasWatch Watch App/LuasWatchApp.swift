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
            LuasView()
        }
        .environmentObject(appModel)
        .modelContainer(sharedModelContainer)

        .onChange(of: scenePhase) {
            switch scenePhase {
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
