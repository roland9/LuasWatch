//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

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
			StationsSelectionModal()
		})
	}

	struct StationsSelectionModal: View {
		@Environment(\.dismiss) private var dismiss
		@EnvironmentObject var appState: AppState

		var body: some View {

			NavigationView(content: {

				ScrollView {
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

					Button(action: {
						switch appState.state {
							case .foundDueTimes(let trains, let location),
									.updatingDueTimes(let trains, let location):
								guard let closest = TrainStations.sharedFromFile.closestStation(from: location, route: trains.trainStation.route.other) else {
									assertionFailure("expected to find closest station from *other* line")
									return
								}
								MyUserDefaults.saveSelectedStation(closest)
								dismiss()
								retriggerTimer()

							default:
								assertionFailure("expected foundDueTimes here")
								return
						}

					}, label: {
						VStack {
							Image(systemName: "location")
							Text("Closest Other Line Station")
								.font(.footnote)
						}
					})

					if MyUserDefaults.userSelectedSpecificStation() != nil {
						Button(action: {
							MyUserDefaults.wipeUserSelectedStation()
							dismiss()
							retriggerTimer()
						}, label: {
							VStack {
								Image(systemName: "location")
								Text("Closest Station")
							}
						})
					}
				}
			})

		}

		@ViewBuilder
		private func greenStationsModal() -> some View {
			StationsModal(stations: TrainStations.sharedFromFile.greenLineStations) {
				dismiss()
			}
		}

		@ViewBuilder
		private func redStationsModal() -> some View {
			StationsModal(stations: TrainStations.sharedFromFile.redLineStations) {
				dismiss()
			}
		}
	}

	struct StationsModal: View {
		@State var stations: [TrainStation]

		/// challenge here: we could use Environment(\.dismiss); but that only dismisses this Stations nav view,
		/// so it's then back to StationsSelection modal.  instead, we want to dismiss the *entire* flow
		var dismissAllModal: () -> Void

		var body: some View {
			// swiftlint:disable multiple_closures_with_trailing_closure
			List {
				ForEach(self.stations, id: \.stationId) { (station) in
					// need a button here because just text only supports tap on the text but not full width
					Button(action: {
						myPrint("☣️ tap \(station) -> save")

						MyUserDefaults.saveSelectedStation(station)

						/// sometimes crash on watchOS 9
						/// [SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior
						DispatchQueue.main.async {
							dismissAllModal()
							/// start 12sec timer right now
							/// this also has logic in there to immediately show this selected station if  we have (quite current) current location

							retriggerTimer()
						}
					}) {
						Text(station.name)
							.font(.system(.headline))
					}
				}
			}
		}
	}
}
// swiftlint:enable multiple_closures_with_trailing_closure

private extension View {

	func retriggerTimer() {
        NotificationCenter.default.post(Notification(name: Notification.Name("LuasWatch.RetriggerTimer")))
	}
}
