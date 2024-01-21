//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct StationView {

    @EnvironmentObject var appModel: AppModel

    @State private var direction: Direction?
}

extension StationView: View {

    var body: some View {

        Group {
            switch appModel.appState {

                case .idle:
                    Text("idle...")

                case .gettingLocation:
                    Text("getting location...")

                case .locationAuthorizationUnknown:
                    // WIP we need new approach to trigger location prompt via appModel?
                    GrantLocationAuthView(didTapButton: {
                        appModel.appState = .gettingLocation
                    })

                case .errorGettingLocation:
                    // we do get error description as well, but we ignore it in UI
                    Text(appModel.appState.description)
                        .multilineTextAlignment(.center)
                        .frame(idealHeight: .greatestFiniteMagnitude)

                case .errorGettingStation(let errorMessage):
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .frame(idealHeight: .greatestFiniteMagnitude)

                case .loadingDueTimes(_, _):
                    // we do get location here in this enum as well, but we ignore it in the UI
                    Text(appModel.appState.description)
                        .multilineTextAlignment(.center)

                case .errorGettingDueTimes(_, _):
                    // this enum has second parameter 'errorString', but it's not shown here
                    // because it's surfaced via the appState's `description`
                    ScrollView {
                        VStack {
                            //                            HeaderView(station: station, direction: $direction)

                            Spacer(minLength: 20)

                            Text(appModel.appState.description)
                                .multilineTextAlignment(.center)
                        }
                    }

                case .foundDueTimes(let trains, let location),
                    .updatingDueTimes(let trains, let location):
                    NavigationStack {

                        VStack {
                            Text(trains.trainStation.name)
                                .font(.title3)
                                .padding(.bottom)

                            Spacer()

                            VStack {
                                ForEach(trains.inbound, id: \.id) {
                                    DueView(destination: $0.destinationDescription, due: $0.dueTimeDescription2)
                                }
                                Divider()
                                ForEach(trains.outbound, id: \.id) {
                                    DueView(destination: $0.destinationDescription, due: $0.dueTimeDescription2)
                                }
                            }
                            .padding(6)
                            .background(.black)
                            .border(.secondary).cornerRadius(2)
                            .padding(4)
                        }

                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    // Perform an action here.
                                } label: {
                                    Image(systemName: "map")
                                }
                            }
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button {
                                    // Perform an action here.
                                } label: {
                                    Image(systemName: "arrow.left.arrow.right")
                                }

                                Button {
                                    // Perform an action here.
                                } label: {
                                    Image(systemName: "heart")
                                }
                            }
                        }
                    }
            }
        }
    }
}

struct DueView: View {
    var destination: String
    var due: String

    var body: some View {

        HStack {
            Text(destination)
                .font(.caption2)
                .monospaced()
            Spacer()
            Text(due)
                .font(.caption2)
                .monospaced()
        }
        .foregroundColor(.yellow)
    }
}
