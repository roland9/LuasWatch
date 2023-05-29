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

struct HeaderView: View {
	var station: TrainStation

	@Binding var direction: Direction?
	@Binding var overlayTextAfterTap: String?

	var body: some View {
		ZStack {

			Image(station.route == .green ? "HeaderGreen" : "HeaderRed")
                .resizable(capInsets: EdgeInsets(top: 12, leading: 54, bottom: 6, trailing: 54), resizingMode: .stretch)
				.frame(maxWidth: .infinity, minHeight: 54, maxHeight: 54, alignment: .trailing)

			HStack {

				Image(systemName: imageName(for: direction ?? .both,
											   allowsSwitchingDirection: self.station.allowsSwitchingDirection))
					.resizable()
					.foregroundColor(.gray)
					.frame(width: 25, height: 25)
					.offset(x: 30)

				Spacer(minLength: 16)

				Text(station.name)
					.lineLimit(1)
					.font(.system(.headline))
					.foregroundColor(.black)
					.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

			}
		}
        .padding(.horizontal)
        .onTapGesture {
            handleTap(station)
		}
	}

	fileprivate func imageName(for direction: Direction,
							   allowsSwitchingDirection: Bool) -> String {
		if !allowsSwitchingDirection {
			// let's not be specific (yet) whether this station is outbound or inbound only
			return "arrow.right.circle.fill"
		}

		switch direction {
		case .both:
			return "arrow.right.arrow.left.circle.fill"
		case .inbound:
			return "arrow.right.circle.fill"
		case .outbound:
			return "arrow.left.circle.fill"
		}
	}

	fileprivate func handleTap(_ trainStation: TrainStation) {
		if trainStation.allowsSwitchingDirection {
			direction = Direction.direction(for: trainStation.name).next()
			Direction.setDirection(for: trainStation.name, to: direction!)
			overlayTextAfterTap = text(for: direction!)
		} else {
			// we don't allow switching direction -> show toast as an explanation
			overlayTextAfterTap = trainStation.isFinalStop ?
			LuasStrings.switchingDirectionsNotAllowedForFinalStop :
			LuasStrings.switchingDirectionsNotAllowedForOnewayStop
		}
	}

	fileprivate func text(for direction: Direction) -> String {
		switch direction {
		case .both:
			return "Showing both directions"
		case .inbound:
			return "Showing inbound trains only"
		case .outbound:
			return "Showing outbound trains only"
		}
	}
}
