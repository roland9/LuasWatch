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
				Text(self.appState.state.description)
					.multilineTextAlignment(.center)
					.frame(idealHeight: .greatestFiniteMagnitude)

			case .errorGettingStation(let errorMessage):
				Text(errorMessage)
					.multilineTextAlignment(.center)
					.frame(idealHeight: .greatestFiniteMagnitude)

					// we do get location here in this enum as well, but we ignore it in the UI
			case .gettingDueTimes:
				Text(self.appState.state.description)
					.multilineTextAlignment(.center)

				// bit confusing: this enum has second parameter 'errorString', but it's not shown here
				// because it's surfaced via the appState's `description`
			case .errorGettingDueTimes(let trainStation, _):

				ScrollView {
					VStack {
						HeaderView(station: trainStation, direction: $direction,
								   overlayTextAfterTap: $overlayTextAfterTap)

						Spacer(minLength: 20)

						Text(self.appState.state.description)
							.multilineTextAlignment(.center)

						ChangeStationButton(isStationsModalPresented: $appState.isStationsModalPresented)
					}
				}

			case .foundDueTimes(let trains, let location):
					foundDueTimesView(for: trains, location: location)

			case .updatingDueTimes(let trains, let location):
					updatingDueTimesView(for: trains, location: location)
			}
		}
	}

	fileprivate func foundDueTimesView(for trains: TrainsByDirection, location: CLLocation) -> some View {
		ZStack {
			VStack {
				HeaderView(station: trains.trainStation, direction: $direction,
						   overlayTextAfterTap: $overlayTextAfterTap)

				TrainsListView(trains: trains, direction: direction ?? .both,
							   location: location)

			}.onAppear {
				forceUpdateDirection(trainStationName: trains.trainStation.name)
			}

			tapOverlayView()
		}
	}

	// not ideal: lots of repetition compared to above
	@ViewBuilder
	fileprivate func updatingDueTimesView(for trains: TrainsByDirection, location: CLLocation) -> some View {
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

			TrainsListView(trains: trains, direction: direction ?? .both,
						   location: location)

		}.onAppear {
			forceUpdateDirection(trainStationName: trains.trainStation.name)
		}
	}

	// challenge: if station changed since last time, it doesn't pick persisted one -> need to force update direction here to fix
	fileprivate func forceUpdateDirection(trainStationName: String) {
		if self.direction != Direction.direction(for: trainStationName) {
			self.direction = Direction.direction(for: trainStationName)
			print("🟢 foundDueTimes -> updated direction \(String(describing: self.direction))")
		}
	}
}
