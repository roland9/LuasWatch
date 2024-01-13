//
//  Created by Roland Gropmair on 13/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit
import SwiftData

@main
struct LuasWatch_Watch_AppApp: App {
    
    @Environment (\.scenePhase) var scenePhase

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([ FavouriteStation.self ])
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
        mainCoordinator = Coordinator(appModel: appModel,
                                      location: location)
        mainCoordinator.start()
    }

    var body: some Scene {

        WindowGroup {
            LuasView2()
        }
        .environmentObject(appModel)
        .modelContainer(sharedModelContainer)

        .onChange(of: scenePhase) {
            switch $0 {
                case .background, .inactive:
                    mainCoordinator.invalidateTimer()

                case .active:
                    mainCoordinator.fireAndScheduleTimer()

                @unknown default:
                    break
            }
        }
    }
}
