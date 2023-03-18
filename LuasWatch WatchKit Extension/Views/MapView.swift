//
//  Created by Roland Gropmair on 18/03/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import MapKit
import LuasKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: TrainStations.cityCentre.location.coordinate,
                                                   span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
    static let stations = TrainStations.sharedFromFile.stations

    var body: some View {

        Map(coordinateRegion: $region, annotationItems: Self.stations) { station in
            MapAnnotation(coordinate: station.location.coordinate) {
                Text("\(station.name)")
                    .onTapGesture(count: 1, perform: {
                      print("IT WORKS")
                    })
            }
        }
    }
}
