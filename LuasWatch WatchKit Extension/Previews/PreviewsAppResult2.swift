//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_AppResult2: PreviewProvider {
	static var previews: some View {

		// there is a limit of 10  views we can pack into a group!
		Group {
			LuasView()
				.environmentObject(
					AppState(state: .errorGettingDueTimes(stationGreen,
														  LuasStrings.noTrainsErrorMessage + "\n\n" +
														  LuasStrings.noTrainsFallbackExplanation)))
				.environment(\.sizeCategory, .extraExtraLarge)
				.previewDisplayName("error getting due times (larger) - not working??")

			LuasView()
				.environmentObject(AppState(state: .foundDueTimes(trainsOneWayStation, userLocation)))
				.previewDisplayName("found - one way stop")

			LuasView()
				.environmentObject(AppState(state: .foundDueTimes(trainsFinalStop, userLocation)))
				.previewDisplayName("found - final stop")
		}
	}
}
#endif
