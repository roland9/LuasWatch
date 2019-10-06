//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation
import LuasKit

struct Header: View {
	var station: TrainStation

	var body: some View {
		ZStack {

			Image(station.route == .green ? "HeaderGreen" : "HeaderRed")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(minWidth: 0, maxWidth: .infinity,
					   minHeight: 36, maxHeight: 36, alignment: .trailing)

			Text(station.name)
				.font(.system(.headline))
				.foregroundColor(.black)
		}
	}
}

struct TrainsList: View {
	let trains: TrainsByDirection

	var body: some View {

		List {
			Section {

				ForEach(trains.inbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}

			Section {

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
					.multilineTextAlignment(.center)
			)

		case .errorGettingLocation:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.multilineTextAlignment(.center)
			)

		case .errorGettingStation(let errorMessage):
			return AnyView (
				ScrollView {
					Text(errorMessage)
						.multilineTextAlignment(.center)
						.frame(idealHeight: .greatestFiniteMagnitude)
				}
			)

		case .gettingDueTimes:
			return AnyView (
				Text(self.appState.state.debugDescription)
					.multilineTextAlignment(.center)
			)

		case .errorGettingDueTimes:
			return AnyView (
				ScrollView {
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
						.frame(idealHeight: .greatestFiniteMagnitude)
				}
			)

		case .foundDueTimes(let trains):
			return AnyView (
				VStack {

					Header(station: trains.trainStation)

					TrainsList(trains: trains)
				}
			)

		case .updatingDueTimes(let trains):
			return AnyView (
				VStack {

					Header(station: trains.trainStation)

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

let stationRed = TrainStation(stationId: "stationId",
							  stationIdShort: "LUAS8",
							  route: .red,
							  name: "Bluebell",
							  location: location)

let trainRed1 = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "Due")
let trainRed2 = Train(destination: "LUAS Tallaght", direction: "Outbound", dueTime: "9")
let trainRed3 = Train(destination: "LUAS Connolly", direction: "Inbound", dueTime: "12")

let trainsRed = TrainsByDirection(trainStation: stationRed,
								  inbound: [trainRed3],
								  outbound: [trainRed1, trainRed2])

let stationGreen = TrainStation(stationId: "stationId",
								stationIdShort: "LUAS69",
								route: .green,
								name: "Phibsboro",
								location: location)

let trainGreen1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
let trainGreen2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
let trainGreen3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

let trainsGreen = TrainsByDirection(trainStation: stationGreen,
									inbound: [trainGreen3],
									outbound: [trainGreen1, trainGreen2])

extension Error {
}

// swiftlint:disable:next type_name
struct Preview_AppStartup: PreviewProvider {
	static let genericErrorGettingStation = "generic error"

	static var previews: some View {

		Group {
			ContentView().environmentObject(AppState(state: .gettingLocation)).previewDisplayName("getting location")

			ContentView().environmentObject(AppState(state: .errorGettingStation(genericErrorGettingStation)))
				.previewDisplayName("generic error getting station")

			ContentView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.environment(\.sizeCategory, .extraLarge)
				.previewDisplayName("error getting station")

			ContentView().environmentObject(AppState(state:
				.gettingDueTimes(TrainStation(stationId: "stationId",
											  stationIdShort: "LUAS70",
											  route: .green,
											  name: "Cabra",
											  location: location)))).previewDisplayName("getting due times")
		}
	}
}

// swiftlint:disable:next type_name
struct Preview_AppRunning: PreviewProvider {
	static var previews: some View {

		Group {
			ContentView().environmentObject(AppState(state: .foundDueTimes(trainsRed))).previewDisplayName("found first due times")

			ContentView().environmentObject(AppState(state: .updatingDueTimes(trainsGreen))).previewDisplayName("updating due times")

			ContentView().environmentObject(AppState(state: .errorGettingDueTimes(String(format: LuasStrings.emptyDueTimesErrorMessage, "Cabra"))))
				//				.environment(\.sizeCategory, .extraLarge)
				.previewDisplayName("no due times found")

		}
	}
}
#endif
