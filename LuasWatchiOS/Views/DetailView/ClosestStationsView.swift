//
//  Created by Roland Gropmair on 02/02/2025.
//  Copyright © 2025 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasAPI
import LuasApp
import SwiftData
import SwiftUI

struct ClosestStationsView: View {
  var userLocation: CLLocation

  var body: some View {
    VStack {
      Text("Closest Stations")
        .font(.headline)

      let fiveClosestStations = TrainStations()
        .closestStationsSorted(from: userLocation)
        .prefix(5)

      List(fiveClosestStations) { station in
        Text(station.name)
      }
    }
  }
}

#Preview {
  let closeLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.00425,
    longitude: locationBluebell.coordinate.longitude + 0.005
  )

  ClosestStationsView(userLocation: closeLocation)
}
