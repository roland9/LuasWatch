//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct StationView: View {

    @Binding var station: TrainStation?

    var body: some View {
        guard let station else {
            return AnyView(Text("Unknown Station"))
        }

        return AnyView(
            NavigationStack {

                VStack {
                    Text("\(station.name)")
                        .font(.title3)
                        .padding(.bottom)

                    Spacer()

                    VStack {
                        DueView(destination: "Broombridge", due: "5min")
                        DueView(destination: "Broombridge", due: "12min")
                        Divider()
                        DueView(destination: "Sandyford", due: "12min")
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
                            Image(systemName:"map")
                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            // Perform an action here.
                        } label: {
                            Image(systemName:"arrow.left.arrow.right")
                        }

                        Button {
                            // Perform an action here.
                        } label: {
                            Image(systemName:"heart")
                        }
                    }
                }
            }
        )
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

#Preview("Station - Cabra") {
    @State var station: TrainStation? =
    TrainStations.sharedFromFile.station(shortCode: "CAB")

    return TabView { StationView(station: $station)
            .containerBackground(station!.route.color.gradient,
                                 for: .tabView)
    }
}

#Preview("Station - Leopardstown Valley") {
    @State var station: TrainStation? =
    TrainStations.sharedFromFile.station(shortCode: "LEO")

    return TabView { StationView(station: $station)
            .containerBackground(station!.route.color.gradient,
                                 for: .tabView)
    }
}

#Preview("Station - Connolly") {
    @State var station: TrainStation? =
    TrainStations.sharedFromFile.station(shortCode: "CON")

    return TabView { StationView(station: $station)
            .containerBackground(station!.route.color.gradient,
                                 for: .tabView)
    }
}
