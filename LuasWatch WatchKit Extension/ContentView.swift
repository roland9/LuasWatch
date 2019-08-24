//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation
import LuasKit

struct TrainsList: View {
	let trains: TrainsByDirection

	var body: some View {

		List {
			Section(header: Text("Inbound")) {

				ForEach(trains.inbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}

			Section(header: Text("Outbound")) {

				ForEach(trains.outbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}
		}
	}
}

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

		case .foundDueTimes(let trains):
			return AnyView (
				VStack {

					Text(trains.trainStation.name)
						.font(.system(.headline))

					TrainsList(trains: trains)
				}
			)

		case .updatingDueTimes(let trains):
			return AnyView (
				VStack {

					Text(trains.trainStation.name)
						.font(.system(.headline))

					Text("Updating...")
						.font(.system(.footnote))

					TrainsList(trains: trains)
				}
			)

		}
	}
}

#if DEBUG
let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)),
						  longitude: CLLocationDegrees(Double(1.2)))

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

// swiftlint:disable:next type_name
struct Preview_AppStartup: PreviewProvider {
	static var previews: some View {

		Group {
			ContentView().environmentObject(AppState(state: .gettingLocation)).previewDisplayName("getting location")

			ContentView().environmentObject(AppState(state: .gettingStation(location))).previewDisplayName("getting station")

			ContentView().environmentObject(AppState(state:
				.gettingDueTimes(TrainStation(stationId: "stationId",
											  stationIdShort: "LUAS70",
											  name: "Cabra",
											  location: location)))).previewDisplayName("getting due times")
		}
	}
}

struct Preview_AppRunning: PreviewProvider {
	static var previews: some View {

		Group {
			ContentView().environmentObject(AppState(state: .foundDueTimes(trains))).previewDisplayName("found first due times")

			ContentView().environmentObject(AppState(state: .updatingDueTimes(trains))).previewDisplayName("updating due times")
		}
	}
}
#endif
