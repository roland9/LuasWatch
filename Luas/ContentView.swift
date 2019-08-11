//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

struct ContentView: View {
	@EnvironmentObject var appState: AppState

    var body: some View {
		Text(appState.state.debugDescription)
    }
}

#if DEBUG
// swiftlint:disable:next type_name
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

		let appState = AppState()

//		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))
//		appState.state = .gettingStation(location)

//		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))
//		let trainStation = TrainStation(stationId: "stationId", name: "Name", location: location)
//		appState.state = .gettingDepartureTimes(trainStation)

		let train1 = Train(destination: "Broombridge", direction: "Outbound", dueTime: "Due")
		let train2 = Train(destination: "Broombridge", direction: "Outbound", dueTime: "9")
		let train3 = Train(destination: "Sandyford", direction: "Inbound", dueTime: "12")

		let trains = TrainsByDirection(inbound: [train1, train2],
									   outbound: [train3])
		appState.state = .foundDepartureTimes(trains)

		return ContentView().environmentObject(appState)
    }
}
#endif
