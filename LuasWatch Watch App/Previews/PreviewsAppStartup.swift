//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_AppStartup: PreviewProvider {

	static let genericAuthError = "Some generic auth error"

	// swiftlint:disable:next line_length
	static let longGenericError = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

	static var previews: some View {

		Group {
            LuasView()
                .environmentObject(AppState(state: .locationAuthorizationUnknown))
                .previewDisplayName("locationAuth unknown")

            LuasView()
				.environmentObject(AppState(state: .gettingLocation))
				.previewDisplayName("getting location")

			LuasView()
				.previewDevice("Apple Watch Series 3 - 38mm")
				.environmentObject(AppState(state: .gettingLocation))
				.environment(\.sizeCategory, .accessibilityExtraExtraLarge)
				.previewDisplayName("getting location (38mm) extra large")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.locationServicesDisabled)))
				.previewDisplayName("error getting location - location services disabled")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.locationAccessDenied)))
				.previewDisplayName("error getting location - location access denied")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(longGenericError)))
				.previewDisplayName("error getting location - location manager error")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.gettingLocationAuthError(genericAuthError))))
				.previewDisplayName("error getting location - auth error")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.gettingLocationOtherError)))
				.previewDisplayName("error getting location - other error")

			LuasView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.previewDisplayName("error getting station - too far away")

			LuasView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.environment(\.sizeCategory, .accessibilityExtraExtraLarge)
				.previewDisplayName("error getting station - too far away (larger)")
		}
	}
}
#endif
