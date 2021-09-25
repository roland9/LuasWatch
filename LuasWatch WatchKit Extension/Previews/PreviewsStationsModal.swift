//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_StationsModal: PreviewProvider {
	@State static var isPresented: Bool = true

	static var previews: some View {

		Group {
			ChangeStationButton.StationsModal(stations: TrainStations.sharedFromFile.greenLineStations,
											  isSheetPresented: $isPresented)
				.previewDisplayName("StationsModal = Green Line")

			ChangeStationButton.StationsModal(stations: TrainStations.sharedFromFile.redLineStations,
											  isSheetPresented: $isPresented)
				.previewDisplayName("StationsModal = Red Line")
		}
	}
}
#endif
