//  Created by Roland Gropmair on 30/01/2022.
//  Copyright © 2022 mApps.ie. All rights reserved.

import SwiftUI
import Combine
import CoreLocation

import LuasKitIOS

struct LuasView: View {

	@EnvironmentObject var appState: AppState

	@State private var direction: Direction?

	@State internal var isAnimating = false

	@State internal var overlayTextAfterTap: String?
	@State internal var overlayTextViewOpacity: Double = 1.0

	var body: some View {

		Group {
			switch appState.state {

			case .gettingLocation:
				loadingAnimationView()

			case .errorGettingLocation:
				Text(self.appState.state.debugDescription)
					.multilineTextAlignment(.center)
					.frame(idealHeight: .greatestFiniteMagnitude)

			case .errorGettingStation(let errorMessage):
				Text(errorMessage)
					.multilineTextAlignment(.center)
					.frame(idealHeight: .greatestFiniteMagnitude)

			case .gettingDueTimes:
				Text(self.appState.state.debugDescription)
					.multilineTextAlignment(.center)

				// bit confusing: this enum has second parameter 'errorString', but it's not shown here
				// because it's surfaced via the appState's `debugDescription`
			case .errorGettingDueTimes(let trainStation, _):
				ScrollView {
					VStack {
						HeaderView(station: trainStation, direction: $direction,
								   overlayTextAfterTap: $overlayTextAfterTap)

						Spacer(minLength: 20)

						Text(self.appState.state.debugDescription)
							.multilineTextAlignment(.center)

						ChangeStationButton(isStationsModalPresented: $appState.isStationsModalPresented)
					}
				}

			case .foundDueTimes(let trains):
				ZStack {
					VStack {

						HeaderView(station: trains.trainStation, direction: $direction,
								   overlayTextAfterTap: $overlayTextAfterTap)

						TrainsListView(trains: trains, direction: direction ?? .both, isStationsModalPresented: $appState.isStationsModalPresented)

					}.onAppear(perform: {
						// challenge: if station changed since last time, it doesn't pick persisted one -> need to force update direction here to fix
						if self.direction != Direction.direction(for: trains.trainStation.name) {
							self.direction = Direction.direction(for: trains.trainStation.name)
							print("🟢 foundDueTimes -> updated direction \(String(describing: self.direction))")
						}
					})

//					tapOverlayView()
				}

			case .updatingDueTimes(let trains):
				// not ideal: lots of repetition compared to above

				VStack {

					ZStack {
						HeaderView(station: trains.trainStation, direction: $direction,
								   overlayTextAfterTap: $overlayTextAfterTap)
						Rectangle()
							.foregroundColor(.black).opacity(0.7)
						Text("Updating...")
							.font(.system(.footnote))
					}
					.frame(height: 36)	// avoid jumping

					TrainsListView(trains: trains, direction: direction ?? .both, isStationsModalPresented: $appState.isStationsModalPresented)

				}.onAppear(perform: {
					if self.direction != Direction.direction(for: trains.trainStation.name) {
						self.direction = Direction.direction(for: trains.trainStation.name)
						print("🟢 foundDueTimes -> updated direction \(String(describing: self.direction))")
					}
				})

			}
		}
    }
}
