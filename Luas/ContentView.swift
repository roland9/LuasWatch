//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

struct ContentView: View {
	@EnvironmentObject var state: AppState

    var body: some View {
		Text(state.state.debugDescription)
    }
}

#if DEBUG
// swiftlint:disable:next type_name
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))
//		return ContentView().environmentObject(AppState(state: .gettingStation(location)))

//		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))
//		let trainStation = TrainStation(stationId: "stationId", name: "Name", location: location)
//		return ContentView().environmentObject(AppState(state: .gettingDepartureTimes(trainStation)))

		let train1 = Train(destination: "Broombridge", direction: "Outbound", dueTime: "Due")
		let train2 = Train(destination: "Broombridge", direction: "Outbound", dueTime: "9")
		let train3 = Train(destination: "Sandyford", direction: "Inbound", dueTime: "12")

		let trains = TrainsByDirection(inbound: [train1, train2],
									   outbound: [train3])
		return ContentView().environmentObject(AppState(state: .foundDepartureTimes(trains)))
    }
}
#endif
