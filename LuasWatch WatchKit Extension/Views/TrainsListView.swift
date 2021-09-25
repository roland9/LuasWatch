//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct TrainsListView: View {
	let trains: TrainsByDirection
	let direction: Direction

	//	@State var isStationsModalPresented = false
	@Binding var isStationsModalPresented: Bool

	var body: some View {

		if trains.trainStation.isFinalStop || trains.trainStation.isOneWayStop {
			// find the trains, either inbound or outbound

			if trains.inbound.count > 0 {
				oneWayTrainsView(trains.inbound)

			} else if trains.outbound.count > 0 {
				oneWayTrainsView(trains.outbound)
			} else {

				// cannot use assert here??
				//				assert(false, "we should have found either trains in inbound or outbound direction")

				VStack {

					VStack {
						Spacer(minLength: 10)
						Text("No Trains found")
						Spacer(minLength: 10)
					}

					ChangeStationButton(isStationsModalPresented: $isStationsModalPresented)
				}
			}

		} else {

			// train station allows switching direction, so let's find out what the user has chosen
			switch direction {

			case .both:
				twoWayTrainsView()

			case .inbound:
				oneWayTrainsView(trains.inbound)

			case .outbound:
				oneWayTrainsView(trains.outbound)
			}
		}
	}

	@ViewBuilder
	private func oneWayTrainsView(_ trainsList: [Train]) -> some View {
		List {
			Section(footer: ChangeStationButton(isStationsModalPresented: $isStationsModalPresented)) {

				ForEach(trainsList, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}
		}
	}

	@ViewBuilder
	private func twoWayTrainsView() -> some View {

		List {
			Section {
				ForEach(self.trains.inbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}

			Section(footer: ChangeStationButton(isStationsModalPresented: $isStationsModalPresented)) {

				ForEach(self.trains.outbound, id: \.id) {
					Text($0.dueTimeDescription)
				}
			}
		}
	}

}

