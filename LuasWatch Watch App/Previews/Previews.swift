//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftData

struct Previews {
    let container: ModelContainer

    lazy var context: ModelContext = {
        ModelContext(container)
    }()

    init(addSample: Bool = true) {
        self.init([
            FavouriteStation.self,
            StationDirection.self,
        ])

        if addSample {
            addSampleData()
        }
    }

    private init(
        _ types: [any PersistentModel.Type],
        isStoredInMemoryOnly: Bool = true
    ) {

        let schema = Schema(types)
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [config])
    }

    mutating func addSampleData() {
        _ = FavouriteStation.addPreviews(into: context)
    }
}

extension FavouriteStation {
    static func addPreviews(into context: ModelContext) -> [FavouriteStation] {
        [
            "RAN",
            "TAL",
            "HOS",
            "KIN",
            "BEE",
            "CCK",
            "GAL",
            "Invalid",
        ]
        .map {
            let station = FavouriteStation(shortCode: $0)
            context.insert(station)
            return station
        }
    }
}
