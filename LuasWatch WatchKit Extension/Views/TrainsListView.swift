//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import CoreLocation

#if os(iOS)
import LuasKitIOS
#endif

#if os(watchOS)
import LuasKit
#endif

struct TrainsListView: View {
	let trains: TrainsByDirection
	let direction: Direction
	let location: CLLocation	// current user location

	@EnvironmentObject var appState: AppState

	var distance: String? {
		guard let distance = trains.trainStation.distance(from: location) else { return nil }

		return LuasStrings.distance(station: trains.trainStation, distance: distance)
	}

	var body: some View {

		if trains.trainStation.isFinalStop || trains.trainStation.isOneWayStop {
			// find the trains, either inbound or outbound

			if trains.inbound.count > 0 {
				oneWayTrainsView(trains.inbound, distanceFooter: distance)

			} else if trains.outbound.count > 0 {
				oneWayTrainsView(trains.outbound, distanceFooter: distance)
			} else {

				// cannot use assert here??
				//				assert(false, "we should have found either trains in inbound or outbound direction")

				VStack {

					VStack {
						Spacer(minLength: 10)
						Text("No Trains found")
						Spacer(minLength: 10)
					}

					ChangeStationButton(isStationsModalPresented: $appState.isStationsModalPresented)
				}
			}

		} else {

			// train station allows switching direction, so let's find out what the user has chosen
			switch direction {

			case .both:
					twoWayTrainsView(distanceFooter: distance)

			case .inbound:
					oneWayTrainsView(trains.inbound, distanceFooter: distance)

			case .outbound:
					oneWayTrainsView(trains.outbound, distanceFooter: distance)
			}
		}
	}

	@ViewBuilder
	private func oneWayTrainsView(_ trainsList: [Train], distanceFooter: String?) -> some View {
		List {
			Section(footer: ChangeStationButtonWithDistance(distanceFooter: distanceFooter)) {

				ForEach(trainsList, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}
		}
	}

	@ViewBuilder
	private func twoWayTrainsView(distanceFooter: String?) -> some View {
		List {
			Section {
				ForEach(self.trains.inbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}

			Section(footer: ChangeStationButtonWithDistance(distanceFooter: distanceFooter)) {

				ForEach(self.trains.outbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}
		}
	}

	@ViewBuilder
	fileprivate func ChangeStationButtonWithDistance(distanceFooter: String?) -> some View {
		VStack {
			ChangeStationButton(isStationsModalPresented: $appState.isStationsModalPresented)

			if let distanceFooter {
				Text(distanceFooter)
					.font(.footnote)
			}
		}
	}
}

