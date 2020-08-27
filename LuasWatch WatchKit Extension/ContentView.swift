//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

#if os(iOS)
import LuasKitIOS
#endif

#if os(watchOS)
import LuasKit
#endif

struct ContentView: View {

	@EnvironmentObject var appState: AppState

	@State private var isAnimating = false
	@State var direction: Direction?
	@State var isGreenLineModalPresented = false
	@State var isRedLineModalPresented = false
	@State var overlayTextAfterTap: String?

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
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
						.frame(idealHeight: .greatestFiniteMagnitude)
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

			// bit confusing: this enum has parameter, but it's not shown here
			// because it's surfaced via the debugDescription
			case .errorGettingDueTimes:
				return AnyView(
					Text(self.appState.state.debugDescription)
						.multilineTextAlignment(.center)
						.contextMenu(menuItems: standardContextMenu)
			)

			case .foundDueTimes(let trains):
				return AnyView(
					VStack {

						Header(station: trains.trainStation, direction: self.direction ?? .both)

						TrainsList(trains: trains, direction: self.direction ?? .both,
								   overlayTextAfterTap: $overlayTextAfterTap)

					}.onAppear(perform: {
						// challenge: if station changed since last time, it doesn't pick persisted one -> need to force update direction here to fix
						if self.direction != Direction.direction(for: trains.trainStation.name) {
							self.direction = Direction.direction(for: trains.trainStation.name)
							print("🟢 foundDueTimes -> updated direction \(String(describing: self.direction))")
						}
					}).onTapGesture {
						withAnimation(.spring()) { self.handleTap(trains.trainStation) }
					}
					.contextMenu(menuItems: standardContextMenu)
			)

			case .updatingDueTimes(let trains):
				return AnyView(
					VStack {

						ZStack {
							Header(station: trains.trainStation, direction: self.direction ?? .both)
							Rectangle()
								.foregroundColor(.black).opacity(0.7)
							Text("Updating...")
								.font(.system(.footnote))
						}
						.frame(height: 36)	// avoid jumping

						TrainsList(trains: trains, direction: self.direction ?? .both,
								   overlayTextAfterTap: $overlayTextAfterTap)

					}.onAppear(perform: {
						if self.direction != Direction.direction(for: trains.trainStation.name) {
							self.direction = Direction.direction(for: trains.trainStation.name)
							print("🟢 foundDueTimes -> updated direction \(String(describing: self.direction))")
						}
					}).onTapGesture {
						withAnimation(.spring()) { self.handleTap(trains.trainStation) }
					}
					.contextMenu(menuItems: standardContextMenu)
			)

		}
	}

	fileprivate func handleTap(_ trainStation: TrainStation) {
		if trainStation.allowsSwitchingDirection {
			self.direction = Direction.direction(for: trainStation.name).next()
			Direction.setDirection(for: trainStation.name, to: self.direction!)
			self.overlayTextAfterTap = text(for: self.direction!)
		} else {
			// we don't allow switching direction -> show toast as an explanation
			self.overlayTextAfterTap = trainStation.isFinalStop ?
				LuasStrings.switchingDirectionsNotAllowedForFinalStop :
				LuasStrings.switchingDirectionsNotAllowedForOnewayStop
		}
	}

	fileprivate func text(for direction: Direction) -> String {
		switch direction {
			case .both:
				return "Showing both directions"
			case .inbound:
				return "Showing inbound trains only"
			case .outbound:
				return "Showing outbound trains only"
		}
	}

	@ViewBuilder
	private func standardContextMenu() -> some View {
		Button(action: {
			self.isGreenLineModalPresented = true
		}, label: {
			VStack {
				Image(systemName: "arrow.up.arrow.down")
				Text("Green Line Station")
			}
		})
			.sheet(isPresented: $isGreenLineModalPresented,
				   content: greenStationsModal)

		Button(action: {
			self.isRedLineModalPresented = true
		}, label: {
			VStack {
				Image(systemName: "arrow.right.arrow.left")
				Text("Red Line Station")
			}
		})
			.sheet(isPresented: $isRedLineModalPresented,
				   content: redStationsModal)

		if MyUserDefaults.userSelectedSpecificStation() != nil {
			Button(action: {
				MyUserDefaults.wipeUserSelectedStation()
				self.retriggerTimer()
			}, label: {
				VStack {
					Image(systemName: "location")
					Text("Closest Station")
				}
			})
		}
	}

	@ViewBuilder
	private func greenStationsModal() -> some View {
		StationsModal(stations: TrainStations.sharedFromFile.greenLineStations,
					  isSheetShowing: $isGreenLineModalPresented)
	}

	@ViewBuilder
	private func redStationsModal() -> some View {
		StationsModal(stations: TrainStations.sharedFromFile.redLineStations,
					  isSheetShowing: $isRedLineModalPresented)
	}
}

struct Header: View {
	var station: TrainStation
	var direction: Direction

	var body: some View {
		ZStack {

			Image(station.route == .green ? "HeaderGreen" : "HeaderRed")
				.resizable()
				.frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .trailing)

			HStack {

				Image(systemName: imageName(for: direction,
											allowsSwitchingDirection: self.station.allowsSwitchingDirection))
					.resizable()
					.foregroundColor(.gray)
					.frame(width: 25, height: 25)
					.offset(x: 12)

				Spacer(minLength: 20)

				Text(station.name)
					.font(.system(.headline))
					.foregroundColor(.black)
					.frame(maxWidth: .infinity, alignment: .leading)

			}

		}
	}

	fileprivate func imageName(for direction: Direction,
							   allowsSwitchingDirection: Bool) -> String {
		if !allowsSwitchingDirection {
			// let's not be specific (yet) whether this station is outbound or inbound only
			return "arrow.right.circle.fill"
		}

		switch direction {
			case .both:
				return "arrow.right.arrow.left.circle.fill"
			case .inbound:
				return "arrow.right.circle.fill"
			case .outbound:
				return "arrow.left.circle.fill"
		}
	}
}

struct TrainsList: View {
	let trains: TrainsByDirection
	let direction: Direction

	@Binding var overlayTextAfterTap: String?
	@State var overlayTextViewOpacity: Double = 1.0

	var body: some View {
		ZStack {
			trainListForDirection()

			tapOverlayView()
		}
	}

	private func trainListForDirection() -> AnyView {

		if trains.trainStation.isFinalStop || trains.trainStation.isOneWayStop {
			// find the trains, either inbound or outbound

			if trains.inbound.count > 0 {
				return oneWayTrainsView(trains.inbound)
			}

			if trains.outbound.count > 0 {
				return oneWayTrainsView(trains.outbound)
			}

			assert(false, "we should have found either trains in inbound or outbound direction")
			return AnyView(
				Text("No Trains found")
					// how to allow user to see standardContextMenu
			)
		}

		// train station allows switching direction, so let's find out what the user has chosen
		switch direction {

			case .both:
				return twoWayTrainsView()

			case .inbound:
				return oneWayTrainsView(trains.inbound)

			case .outbound:
				return oneWayTrainsView(trains.outbound)
		}
	}

	private func oneWayTrainsView(_ trainsList: [Train]) -> AnyView {
		AnyView(
			ZStack {
				List {
					ForEach(trainsList, id: \.id) {
						Text($0.dueTimeDescription)
					}
				}
			}
		)
	}

	private func twoWayTrainsView() -> AnyView {
		return AnyView(
			ZStack {
				List {
					Section {
						ForEach(self.trains.inbound, id: \.id) {
							Text($0.dueTimeDescription)
						}
					}

					Section {
						ForEach(self.trains.outbound, id: \.id) {
							Text($0.dueTimeDescription)
						}
					}
				}
			}
		)
	}

	public func tapOverlayView() -> AnyView? {
		guard let text = overlayTextAfterTap else { return nil }

		return AnyView(

			ZStack {
				Rectangle()
					.foregroundColor(.black).opacity(0.59)
				VStack {
					Text(text)
						.font(.body)
						.multilineTextAlignment(.center)
				}
			}
			.frame(maxHeight: 100)
			.opacity(self.overlayTextViewOpacity)
			.onAppear {
				withAnimation(Animation.easeOut.delay(1.5)) {
					self.overlayTextViewOpacity = 0.0
				}

				// a bit ugly: reset so we're ready to show if user taps again
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					self.overlayTextAfterTap = nil
					self.overlayTextViewOpacity = 1.0
				}
			}
		)
	}
}

extension View {
	func retriggerTimer() {

		#if os(watchOS)
		// swiftlint:disable:next force_cast
		let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate

		// this is ugly, just to get the coordinator and retrigger timer - is there a better way?
		extensionDelegate.mainCoordinator.retriggerTimer()
		#endif
	}
}

struct StationsModal: View {
	@State var stations: [TrainStation]
	@Binding var isSheetShowing: Bool

	var body: some View {
		// swiftlint:disable multiple_closures_with_trailing_closure
		List {
			ForEach(self.stations, id: \.stationId) { (station) in
				// need a button here because just text only supports tap on the text but not full width
				Button(action: {
					print("☣️ tap \(station) -> save")
					MyUserDefaults.saveSelectedStation(station)
					self.retriggerTimer()			// start 12sec timer right now
					self.isSheetShowing = false		// so we dismiss sheet
				}) {
					Text(station.name)
				}
			}
		}
		// swiftlint:enable multiple_closures_with_trailing_closure
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

let stationOneWay = TrainStation(stationId: "stationId",
								 stationIdShort: "LUAS69",
								 route: .green,
								 name: "Marlborough",
								 location: location,
								 stationType: .oneway)
let trainsOneWayStation = TrainsByDirection(trainStation: stationOneWay,
											inbound: [trainGreen2, trainGreen3],
											outbound: [])

let stationFinalStop = TrainStation(stationId: "stationId",
									stationIdShort: "stationIdShort",
									route: .red,
									name: "Tallaght",
									location: location,
									stationType: .terminal)
let trainsFinalStop = TrainsByDirection(trainStation: stationFinalStop,
										inbound: [trainRed1, trainRed3],
										outbound: [])
let directionBoth: Direction = .both

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
				.previewDisplayName("getting location (38mm) extra large")

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

			ContentView()
				.environmentObject(AppState(state: .foundDueTimes(trainsOneWayStation)))
				.previewDisplayName("found due times - one way stop")

			ContentView()
				.environmentObject(AppState(state: .foundDueTimes(trainsFinalStop)))
				.previewDisplayName("found due times - final stop")
		}
	}
}

// swiftlint:disable:next type_name
struct Preview_AppOverlay: PreviewProvider {

	@State static var overlayTextFinalStop: String? = LuasStrings.switchingDirectionsNotAllowedForFinalStop
	@State static var overlayTextOnewayStop: String? = LuasStrings.switchingDirectionsNotAllowedForOnewayStop

	static var previews: some View {

		// need to comment the animation if you want to preview this here
		Group {

			TrainsList(trains: trainsGreen, direction: directionBoth, overlayTextAfterTap: $overlayTextFinalStop)
				.previewDisplayName("Overlay 'final stop'")

			TrainsList(trains: trainsGreen, direction: directionBoth, overlayTextAfterTap: $overlayTextOnewayStop)
				.previewDisplayName("Overlay 'one-way stop'")
		}
	}
}

// swiftlint:disable file_length
#endif
