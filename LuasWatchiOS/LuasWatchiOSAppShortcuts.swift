//
//  Created by Roland Gropmair on 09/06/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import AppIntents

struct LuasWatchiOSAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LuasWatchSpecificStationAppIntent(),
            phrases: ["LUAS due times"],
            shortTitle: "LuasWatch Due Times",
            systemImageName: "train.side.front.car"
        )
    }
}
