//
//  Created by Roland Gropmair on 25/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationTimesViewLoadingFirstTime: View {

    @Environment(\.modelContext) private var modelContext

    var trainStation: TrainStation
}

extension StationTimesViewLoadingFirstTime {

    var body: some View {

        NavigationStack {

            VStack {
                Text(trainStation.name)
                    .font(.title3)
                    .padding(.bottom)

                Spacer()

                TrainsViewLoading()
                    .timeTableStyle()
            }

            .toolbar {
                StationToolbarLoading(
                    isFavourite: modelContext.doesFavouriteStationExist(shortCode: trainStation.shortCode),
                    direction: modelContext.directionConsideringStationType(for: trainStation.shortCode),
                    isSwitchingDirectionEnabled: trainStation.allowsSwitchingDirection)
            }
        }
    }
}
