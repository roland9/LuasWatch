//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation
import LuasKit

struct ContentView: View {
	@EnvironmentObject var appState: AppState

	var body: some View {

		switch appState.state {

		case .gettingLocation:
			return AnyView (
				Text(self.appState.state.debugDescription)
			)

		case .errorGettingLocation:
			return AnyView (
				Text(self.appState.state.debugDescription)
			)

		case .gettingStation:
			return AnyView (
				Text(self.appState.state.debugDescription)
			)

		case .errorGettingStation:
			return AnyView (
				Text(self.appState.state.debugDescription)
			)

		case .gettingDepartureTimes:
			return AnyView (
				Text(self.appState.state.debugDescription)
			)

		case .errorGettingDepartureTimes:
			return AnyView (
				Text(self.appState.state.debugDescription)
			)

		case .foundDepartureTimes(let trainsByDirection):
			return AnyView (

				VStack {

					Text(trainsByDirection.trainStation.name)
						.font(.system(.headline))

					List {
						Section(header: Text("Inbound")) {

							ForEach(trainsByDirection.inbound, id: \.id) {
								Text($0.dueTimeDescription)
							}
						}

						Section(header: Text("Outbound")) {

							ForEach(trainsByDirection.outbound, id: \.id) {
								Text($0.dueTimeDescription)
							}
						}
					}

				}
			)
		}
	}
}

#if DEBUG
// swiftlint:disable:next type_name
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {

		let appState = AppState()

		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))

		//		appState.state = .gettingStation(location)

		//		let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)), longitude: CLLocationDegrees(Double(1.2)))
		//		let trainStation = TrainStation(stationId: "stationId", name: "Name", location: location)
		//		appState.state = .gettingDepartureTimes(trainStation)

		let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
		let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
		let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

		let station = TrainStation(stationId: "stationId",
								   stationIdShort: "LUAS8",
								   name: "Bluebell",
								   location: location)

		let trains = TrainsByDirection(trainStation: station,
									   inbound: [train1, train2],
									   outbound: [train3])
		appState.state = .foundDepartureTimes(trains)

		return ContentView().environmentObject(appState)
	}
}
#endif
