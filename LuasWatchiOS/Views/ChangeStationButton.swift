//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI

#if os(iOS)
import LuasKitIOS
#endif

#if os(watchOS)
import LuasKit
#endif

struct ChangeStationButton: View {

	@Binding var isStationsModalPresented: Bool

	var body: some View {

		VStack {

			Spacer(minLength: 30)

			Button("Select other station") {
				isStationsModalPresented = true
			}
			.frame(maxHeight: 32)
			.background(Color(red: 82/255, green: 53/255, blue: 214/255, opacity: 0.8))
			.cornerRadius(12)
		}
		.sheet(isPresented: $isStationsModalPresented, content: {
			StationsSelectionModal(isStationsModalPresented: $isStationsModalPresented)
		})
	}

	struct StationsSelectionModal: View {

		@Binding var isStationsModalPresented: Bool

		var body: some View {

			NavigationView(content: {
				NavigationLink(destination: greenStationsModal()) {
					VStack {
						Image(systemName: "arrow.up.arrow.down")
						Text("Green Line Stations")
					}
				}

				NavigationLink(destination: redStationsModal()) {
					VStack {
						Image(systemName: "arrow.right.arrow.left")
						Text("Red Line Stations")
					}
				}

				if MyUserDefaults.userSelectedSpecificStation() != nil {
					Button(action: {
						MyUserDefaults.wipeUserSelectedStation()
						isStationsModalPresented = false
						retriggerTimer()
					}, label: {
						VStack {
							Image(systemName: "location")
							Text("Closest Station")
						}
					})
				}

			})

		}

		@ViewBuilder
		private func greenStationsModal() -> some View {
			StationsModal(stations: TrainStations.sharedFromFile.greenLineStations,
						  isSheetPresented: $isStationsModalPresented)
		}

		@ViewBuilder
		private func redStationsModal() -> some View {
			StationsModal(stations: TrainStations.sharedFromFile.redLineStations,
						  isSheetPresented: $isStationsModalPresented)
		}
	}

	struct StationsModal: View {
		@State var stations: [TrainStation]
		@Binding var isSheetPresented: Bool

		var body: some View {
			// swiftlint:disable multiple_closures_with_trailing_closure
			List {
				ForEach(self.stations, id: \.stationId) { (station) in
					// need a button here because just text only supports tap on the text but not full width
					Button(action: {
						print("☣️ tap \(station) -> save")
						MyUserDefaults.saveSelectedStation(station)
						isSheetPresented = false		// so we dismiss sheet
						retriggerTimer()			// start 12sec timer right now
					}) {
						Text(station.name)
							.font(.system(.headline))
					}
				}
			}
			// swiftlint:enable multiple_closures_with_trailing_closure
		}
	}
}

private extension View {
	func retriggerTimer() {

#if os(watchOS)
		// swiftlint:disable:next force_cast
		let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate

		// this is ugly, just to get the coordinator and retrigger timer - is there a better way?
		extensionDelegate.mainCoordinator.retriggerTimer()
#endif
	}
}
