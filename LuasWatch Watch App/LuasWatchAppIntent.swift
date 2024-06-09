//
//  Created by Roland Gropmair on 07/06/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import AppIntents
import LuasKit

struct LuasWatchAppIntent: AppIntent {
    static var title: LocalizedStringResource = "LuasWatch Times"

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let resultText = "next luas to broombridge in 5 minutes"
        return .result(value: resultText)
    }
}

struct LuasWatchAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LuasWatchAppIntent(),
            phrases: ["LuasWatch departures"],
            shortTitle: "LuasWatch times",
            systemImageName: "train.side.front.car"
        )
    }
}
