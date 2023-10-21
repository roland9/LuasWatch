//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_AppResult: PreviewProvider {
	static var previews: some View {

		Group {
			LuasView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_1_1, userLocation)))
				.previewDisplayName("found - 1:1")

			LuasView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_1_1, location)))
				.previewDisplayName("found - close")

			LuasView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_2_1, userLocation)))
				.previewDisplayName("found - 2:1")

			LuasView()
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_3_2, userLocation)))
				.previewDisplayName("found - 3:2")

			LuasView().previewDevice("Apple Watch Series 3 - 38mm")
				.environmentObject(AppState(state: .foundDueTimes(trainsRed_4_4, userLocation)))
				.previewDisplayName("found - small 4:4")

			LuasView()
				.environmentObject(AppState(state: .updatingDueTimes(trainsGreen, userLocation)))
				.previewDisplayName("updating")

			LuasView()
				.environmentObject(
					AppState(
						state: .errorGettingDueTimes(stationGreen,
													 "No service Broombridge-Parnell. See news.")))
				.previewDisplayName("error - API")  // message coming from API
			LuasView()
				.environmentObject(
					AppState(
						state: .errorGettingDueTimes(stationGreen,
													 LuasStrings.noTrainsErrorMessage + "\n\n" +
													 LuasStrings.noTrainsFallbackExplanation)))
				.previewDisplayName("error - fallback") // showing fallback message

		}
	}
}
#endif
