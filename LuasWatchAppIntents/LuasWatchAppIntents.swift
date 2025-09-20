//
//  Created by Roland Gropmair on 20/09/2025.
//  Copyright © 2025 mApps.ie. All rights reserved.
//

import AppIntents

struct LuasWatchAppIntents: AppIntent {
    static var title: LocalizedStringResource { "LuasWatchAppIntents" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
