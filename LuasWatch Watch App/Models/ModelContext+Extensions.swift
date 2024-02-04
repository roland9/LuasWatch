//
//  Created by Roland Gropmair on 04/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import SwiftData

extension ModelContext {

    func doesFavouriteStationExist(shortCode: String) -> Bool {

        favouriteStation(shortCode: shortCode) != nil
    }

    func favouriteStation(shortCode: String) -> FavouriteStation? {
        let descriptor = FetchDescriptor<FavouriteStation>(
            predicate: #Predicate {
                $0.shortCode == shortCode
            })

        return try? fetch(descriptor).first
    }

    func toggleFavouriteStation(shortCode: String) {

        if let favourite = favouriteStation(shortCode: shortCode) {
            delete(favourite)
        } else {
            insert(FavouriteStation(shortCode: shortCode))
        }
    }
}
