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
					.padding(.horizontal)
			)

		case .errorGettingLocation:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.padding(.horizontal)
			)

		case .gettingStation:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.padding(.horizontal)
			)

		case .errorGettingStation:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.padding(.horizontal)
			)

		case .gettingDueTimes:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.padding(.horizontal)
			)

		case .errorGettingDueTimes:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.padding(.horizontal)
			)

		case .foundDueTimes(let trainsByDirection):
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
let appState = AppState()
let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)),
						  longitude: CLLocationDegrees(Double(1.2)))

// swiftlint:disable:next type_name
struct ContentView_Preview_GettingLocation: PreviewProvider {
	static var previews: some View {

		appState.state = .gettingLocation

		return ContentView().environmentObject(appState)
	}
}

struct ContentView_Preview_GettingStation: PreviewProvider {
	static var previews: some View {

		appState.state = .gettingStation(location)

		return ContentView().environmentObject(appState)
	}
}

struct ContentView_Preview_GettingDueTimes: PreviewProvider {
	static var previews: some View {

		let trainStation = TrainStation(stationId: "stationId", stationIdShort: "LUAS70", name: "Cabra", location: location)

		appState.state = .gettingDueTimes(trainStation)

		return ContentView().environmentObject(appState)
	}
}

struct ContentView_Preview_Done: PreviewProvider {
	static var previews: some View {

		let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
		let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
		let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

		let station = TrainStation(stationId: "stationId",
								   stationIdShort: "LUAS8",
								   name: "Bluebell",
								   location: location)

		let trains = TrainsByDirection(trainStation: station,
									   inbound: [train3],
									   outbound: [train1, train2])
		appState.state = .foundDueTimes(trains)

		return ContentView().environmentObject(appState)
	}
}
#endif
