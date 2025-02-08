//
//  Created by Roland Gropmair on 08/02/2025.
//  Copyright © 2025 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftUI
import MapKit

struct StationsMapsView: View {

  var userLocation: CLLocation

  @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

  var body: some View {
    Map {
      ForEach(TrainStations().closestStationsSorted(from: userLocation).prefix(10)) {
        Marker($0.name, coordinate: $0.location.coordinate)
          .tint($0.route == .red ? .luasRed : .luasGreen)
      }
    }
    .mapControlVisibility(.visible)
    .mapStyle(.standard(pointsOfInterest: .all))
  }
}

//Annotation("Diller Civic Center Playground", coordinate: userLocation.coordinate) {
//  ZStack {
//    RoundedRectangle(cornerRadius: 5)
//      .fill(Color.yellow)
//    Text("🛝")
//      .padding(5)
//  }
//}

#Preview {
  StationsMapsView(userLocation: locationMarlborough)
}
