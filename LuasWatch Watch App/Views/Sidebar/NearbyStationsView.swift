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
                .fontWeight(appModel.appMode == .closest ? .bold : .regular)
            }
        ).disabled(appModel.locationDenied == true)

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
                .fontWeight(appModel.appMode == .closestOtherLine ? .bold : .regular)

            }
        ).disabled(appModel.locationDenied == true)
    }
}

#if DEBUG
    #Preview("Nearby") {
        let appModel = AppModel(AppModel.AppState(.foundDueTimes(trainsOneWayStation)))
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
#endif
