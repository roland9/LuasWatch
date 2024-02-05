//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct StationView {

    @EnvironmentObject var appModel: AppModel
    @Environment(\.modelContext) private var modelContext

    @State private var direction: Direction?

    // have to let SwiftUI know that underlying context has changed -  can we avoid the isFavourite state?
    @State private var isFavourite: Bool = false

    @State private var isSwitchingDirectionEnabled: Bool = true
}

extension View {

    fileprivate func timeTableStyle() -> some View {
        self
            .padding(6)
            .background(.black)
            .border(.secondary).cornerRadius(2)
            .padding(4)
    }
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

                case .loadingDueTimes(_):
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

                case .foundDueTimes(let trains),
                    .updatingDueTimes(let trains):

                    NavigationStack {

                        VStack {
                            Text(trains.trainStation.name)
                                .font(.title3)
                                .padding(.bottom)

                            Spacer()

                            switch direction {
                                case .inbound:
                                    Spacer()
                                    VStack {
                                        ForEach(trains.inbound, id: \.id) {
                                            DueView(destination: $0.destinationDescription, due: $0.dueTimeDescription2)
                                        }
                                    }
                                    .timeTableStyle()
                                    Spacer()

                                case .outbound:
                                    Spacer()
                                    VStack {
                                        ForEach(trains.outbound, id: \.id) {
                                            DueView(destination: $0.destinationDescription, due: $0.dueTimeDescription2)
                                        }
                                    }
                                    .timeTableStyle()
                                    Spacer()

                                case .both:
                                    VStack {
                                        ForEach(trains.inbound, id: \.id) {
                                            DueView(destination: $0.destinationDescription, due: $0.dueTimeDescription2)
                                        }
                                        Divider()
                                        ForEach(trains.outbound, id: \.id) {
                                            DueView(destination: $0.destinationDescription, due: $0.dueTimeDescription2)
                                        }
                                    }
                                    .timeTableStyle()

                                case .none:
                                    Text("None")
                            }
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

                                /// Change direction
                                Button {
                                    withAnimation {
                                        direction = direction?.next()
                                    }
                                    if let direction {
                                        modelContext.createOrUpdate(shortCode: trains.trainStation.shortCode, to: direction)
                                    }
                                } label: {
                                    switch direction {

                                        case .inbound:
                                            Image(systemName: "arrow.left")
                                        case .outbound:
                                            Image(systemName: "arrow.right")
                                        case .both:
                                            Image(systemName: "arrow.left.arrow.right")
                                        case .none:  // because it's optional
                                            Image(systemName: "arrow.left.arrow.right")
                                    }
                                }
                                .onAppear {
                                    isSwitchingDirectionEnabled = trains.trainStation.allowsSwitchingDirection
                                    direction = modelContext.directionConsideringStationType(for: trains.trainStation.shortCode)
                                    print("😍 on appear \(trains.trainStation.shortCode)  isSwitchingDirectionEnabled \(isSwitchingDirectionEnabled)")
                                }
                                .onChange(
                                    of: appModel.selectedStation,
                                    { oldValue, newValue in
                                        print("😇 onChange old \(oldValue) \(newValue)")
                                    }
                                )
                                .disabled(!isSwitchingDirectionEnabled)

                                /// Favourite
                                Button {
                                    modelContext.toggleFavouriteStation(shortCode: trains.trainStation.shortCode)
                                    isFavourite.toggle()
                                } label: {
                                    isFavourite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                                }
                                .onAppear {
                                    isFavourite = modelContext.doesFavouriteStationExist(shortCode: trains.trainStation.shortCode)
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
