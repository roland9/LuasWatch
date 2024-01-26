//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct NearbyStationsView {

    @EnvironmentObject var appModel: AppModel
}

extension NearbyStationsView: View {

    var body: some View {

        Button(
            action: { appModel.appMode = .closest },
            label: {
                HStack {
                    Text("Closest station")
                    Spacer()
                    Image(systemName: "location.fill.viewfinder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 24)
                }
            })

        Button(
            action: { appModel.appMode = .closestOtherLine },
            label: {
                HStack {
                    Text("Closest other line station")
                    Spacer()
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 24)
                }

            })
    }
}

#Preview("Nearby") {
    let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation, userLocation)))
    appModel.appMode = .favourite(stationGreen)

    return List {
        Section {
            NearbyStationsView()
                .environmentObject(appModel)
        } header: {
            Text("Nearby")
                .font(.subheadline)
                .frame(minHeight: 40)
        }
    }
}
