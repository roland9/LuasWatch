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

	@State private var isAnimating = false
	@State var direction: Direction = .both

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
				return AnyView(
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
				return AnyView(
					ScrollView {
						Text(self.appState.state.debugDescription)
							.multilineTextAlignment(.center)
							.frame(idealHeight: .greatestFiniteMagnitude)
					}
			)

			case .errorGettingStation(let errorMessage):
				return AnyView(
					Text(errorMessage)
						.multilineTextAlignment(.center)
						.frame(idealHeight: .greatestFiniteMagnitude)
			)

			case .gettingDueTimes:
				return AnyView(
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
			)

			case .errorGettingDueTimes:
				return AnyView(
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
			)

			case .foundDueTimes(let trains):
				return AnyView(
					VStack {

						Header(station: trains.trainStation)

						TrainsList(trains: trains,
								   direction: self.direction)
					}.onTapGesture {
						self.direction = self.direction.next()
						Direction.setDirection(for: trains.trainStation.name, to: self.direction)
					}
			)

			case .updatingDueTimes(let trains):
				return AnyView(
					VStack {

						Header(station: trains.trainStation)

						Text("Updating...")
							.font(.system(.footnote))

						TrainsList(trains: trains,
								   direction: self.direction)
					}.onTapGesture {
						self.direction = self.direction.next()
						Direction.setDirection(for: trains.trainStation.name, to: self.direction)
					}
			)

		}
	}
}

struct Header: View {
	var station: TrainStation

	var body: some View {
		ZStack {

			Image(station.route == .green ? "HeaderGreen" : "HeaderRed")
				.resizable()
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
	let direction: Direction

	var body: some View {
		// this hack is required because Xcode 11 doesn't like switch statements in a View
			trainListForDirection()
	}

	private func trainListForDirection() -> AnyView {
		switch direction {

			case .both:
				return AnyView(
					List {
						Section {
							ForEach(self.trains.inbound, id: \.id) {
								Text($0.dueTimeDescription)
							}
						}

						Section(footer: Footer(direction: self.direction)) {
							ForEach(self.trains.outbound, id: \.id) {
								Text($0.dueTimeDescription)
							}
						}
					}
			)

			case .inbound:
				return AnyView(
					List {
						ForEach(self.trains.inbound, id: \.id) {
							Text($0.dueTimeDescription)
						}
					}
			)

			case .outbound:
				return AnyView(
					List {
						ForEach(self.trains.outbound, id: \.id) {
							Text($0.dueTimeDescription)
						}
					}
			)
		}
	}
}

struct Footer: View {
	@State private var isExplanationShown = true
	let direction: Direction

	var body: some View {

		VStack {
			Spacer()
			Text(direction.text())
				.fontWeight(.heavy)
				.frame(maxWidth: .infinity, alignment: .center)
			if isExplanationShown {
				Text("Tap to switch direction")
					.fontWeight(.thin)
					.multilineTextAlignment(.center)
			}
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				self.isExplanationShown = false
			}
		}

	}
}

#if DEBUG
////  Previews
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

let trainsRed_1_1 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed3],
									  outbound: [trainRed2])
let trainsRed_2_1 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed3],
									  outbound: [trainRed2])
let trainsRed_3_2 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed2, trainRed3],
									  outbound: [trainRed1, trainRed2])
let trainsRed_4_4 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed2, trainRed3, trainRed3],
									  outbound: [trainRed1, trainRed2, trainRed3, trainRed3])

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

// swiftlint:disable:next type_name
struct Preview_AppStartup: PreviewProvider {

	static let genericError = "Some generic error"

	// swiftlint:disable:next line_length
	static let longGenericError = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

	static var previews: some View {

		Group {
			ContentView()
				.environmentObject(AppState(state: .gettingLocation))
				.previewDisplayName("getting location")

			ContentView()
				.previewDevice("Apple Watch Series 3 - 38mm")
				.environmentObject(AppState(state: .gettingLocation))
				.environment(\.sizeCategory, .accessibilityExtraExtraLarge)
				.previewDisplayName("getting location (38mm)")

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
	static let genericError = "Some generic error"

	static var previews: some View {

		Group {
			ContentView()
				.environmentObject(
					AppState(state:
						.gettingDueTimes(TrainStation(stationId: "stationId",
													  stationIdShort: "LUAS70",
													  route: .green,
													  name: "Cabra",
													  location: location))))
				.previewDisplayName("getting info")

			ContentView()
				.environmentObject(AppState(state:
					.errorGettingDueTimes(genericError)))
				.previewDisplayName("error getting due times (specific)")

			ContentView()
				.environmentObject(AppState(state: .errorGettingDueTimes(LuasStrings.errorGettingDueTimes)))
				.previewDisplayName("error getting due times (generic)")

			ContentView()
				.environmentObject(AppState(state: .errorGettingDueTimes(LuasStrings.errorNoInternet)))
				.previewDisplayName("error getting due times (offline)")
		}
	}
}

// swiftlint:disable:next type_name
struct Preview_AppResult: PreviewProvider {
	static var previews: some View {

		Group {
			ContentView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_1_1)))
				.previewDisplayName("found due times - 1:1")

			ContentView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_2_1)))
				.previewDisplayName("found due times - 2:1")

			ContentView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_3_2)))
				.previewDisplayName("found due times - 3:2")

			ContentView().previewDevice("Apple Watch Series 3 - 38mm")
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_4_4)))
				.previewDisplayName("Small watch - found due times - 4:4")

			ContentView()
				.environmentObject(AppState(state: .updatingDueTimes(trainsGreen)))
				.previewDisplayName("updating due times")

			ContentView()
				.environmentObject(
					AppState(state: .errorGettingDueTimes(String(format: LuasStrings.emptyDueTimesErrorMessage, "Cabra"))))
				.previewDisplayName("error getting due times")

			ContentView()
				.environmentObject(
					AppState(state: .errorGettingDueTimes(String(format: LuasStrings.emptyDueTimesErrorMessage, "Cabra"))))
				.environment(\.sizeCategory, .extraExtraLarge)
				.previewDisplayName("error getting due times (larger)")
		}
	}
}
#endif
