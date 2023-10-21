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
				.environmentObject(AppState(state: .gettingLocation))
				.previewDisplayName("getting")

			LuasView()
				.previewDevice("Apple Watch Series 3 - 38mm")
				.environmentObject(AppState(state: .gettingLocation))
				.environment(\.sizeCategory, .accessibilityExtraExtraLarge)
				.previewDisplayName("getting XXL")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.locationServicesDisabled)))
				.previewDisplayName("disabled")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.locationAccessDenied)))
				.previewDisplayName("denied")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(longGenericError)))
				.previewDisplayName("locman error")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.gettingLocationAuthError(genericAuthError))))
				.previewDisplayName("auth")

			LuasView().environmentObject(AppState(state: .errorGettingLocation(LuasStrings.gettingLocationOtherError)))
				.previewDisplayName("other")

			LuasView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.previewDisplayName("error - too far away")

			LuasView().environmentObject(AppState(state: .errorGettingStation(LuasStrings.tooFarAway)))
				.environment(\.sizeCategory, .accessibilityExtraExtraLarge)
				.previewDisplayName("error - too far away 2")
		}
	}
}
#endif
