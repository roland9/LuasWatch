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
	@State private var isAnimating = false

	var animation: Animation {
		Animation
			.easeInOut(duration: 0.7)
			.repeatForever()
	}

	var slowAnimation: Animation {
		Animation
			.easeInOut(duration: 1.4)
			.repeatForever()
	}

	var body: some View {

		switch appState.state {

			case .gettingLocation:
				return AnyView (
					VStack {
						Text(self.appState.state.debugDescription)
							.multilineTextAlignment(.center)
							.padding()

						ZStack {

							Circle()
								.stroke(Color(UIColor.luasPurple), lineWidth: 6)
								.scaleEffect(isAnimating ? 2.8 : 1)
								.animation(slowAnimation)
								.blur(radius: 8)

							Circle()
								.fill(Color(UIColor.luasGreen))
								.scaleEffect(isAnimating ? 1.5 : 1)
								.animation(animation)

							Circle()
								.stroke(Color(UIColor.luasRed), lineWidth: 3)
								.scaleEffect(isAnimating ? 2.0 : 1)
								.animation(slowAnimation)

						}.frame(width: CGFloat(20), height: CGFloat(20))
							.onAppear { self.isAnimating = true }
							.padding(25)
					}
			)

			case .errorGettingLocation:
				return AnyView (
					ScrollView {
						Text(self.appState.state.debugDescription)
							.multilineTextAlignment(.center)
							.frame(idealHeight: .greatestFiniteMagnitude)
					}
			)

			case .errorGettingStation(let errorMessage):
				return AnyView (
					Text(errorMessage)
						.multilineTextAlignment(.center)
						.frame(idealHeight: .greatestFiniteMagnitude)
			)

			case .gettingDueTimes:
				return AnyView (
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
			)

			case .errorGettingDueTimes:
				return AnyView (
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
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
	static let genericError = "generic error"
	// swiftlint:disable:next line_length
	static let longGenericError = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

	static var previews: some View {

		Group {
			ContentView().environmentObject(AppState(state: .gettingLocation)).previewDisplayName("getting location")

			ContentView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.locationServicesDisabled)))
				.previewDisplayName("error getting location - location services disabled")

			ContentView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.locationAccessDenied)))
				.previewDisplayName("error getting location - location access denied")

			ContentView().environmentObject(AppState(state: .errorGettingLocation(longGenericError)))
				.previewDisplayName("error getting location - location manager error")

			ContentView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.gettingLocationAuthError(genericError))))
				.previewDisplayName("error getting location - auth error")

			ContentView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.gettingLocationOtherError)))
				.previewDisplayName("error getting location - other error")

			ContentView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.previewDisplayName("error getting station - too far away")

			ContentView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.environment(\.sizeCategory, .accessibilityExtraExtraLarge)
				.previewDisplayName("error getting station - too far away (larger)")
		}
	}
}

// swiftlint:disable:next type_name
struct Preview_AppRunning: PreviewProvider {
	static let genericError = "generic error"

	static var previews: some View {

		Group {
			ContentView().environmentObject(AppState(state:
				.gettingDueTimes(TrainStation(stationId: "stationId",
											  stationIdShort: "LUAS70",
											  route: .green,
											  name: "Cabra",
											  location: location))))
				.previewDisplayName("getting info")

			ContentView().environmentObject(AppState(state:
				.errorGettingDueTimes(genericError)))
				.previewDisplayName("error getting due times (specific)")

			ContentView().environmentObject(AppState(state: .errorGettingDueTimes(LuasStrings.errorGettingDueTimes)))
				.previewDisplayName("error getting due times (generic)")

			ContentView().environmentObject(AppState(state: .errorGettingDueTimes(LuasStrings.errorNoInternet)))
				.previewDisplayName("error getting due times (offline)")

			ContentView().environmentObject(AppState(state: .foundDueTimes(trainsRed)))
				.previewDisplayName("found due times")

			ContentView().environmentObject(AppState(state: .updatingDueTimes(trainsGreen))).previewDisplayName("updating due times")

			ContentView().environmentObject(AppState(state: .errorGettingDueTimes(String(format: LuasStrings.emptyDueTimesErrorMessage, "Cabra"))))
				.previewDisplayName("error getting due times")

			ContentView().environmentObject(AppState(state: .errorGettingDueTimes(String(format: LuasStrings.emptyDueTimesErrorMessage, "Cabra"))))
				.environment(\.sizeCategory, .extraExtraLarge)
				.previewDisplayName("error getting due times (larger)")
		}
	}
}
#endif
