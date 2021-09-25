//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

extension LuasView {

	@ViewBuilder
	internal func loadingAnimationView() -> some View {

		VStack {
			Text(self.appState.state.debugDescription)
				.multilineTextAlignment(.center)
				.padding()

			ZStack {

				Circle()
					.stroke(Colors.luasPurple, lineWidth: 6)
					.scaleEffect(isAnimating ? 2.8 : 1)
					.animation(slowAnimation)
					.blur(radius: 8)

				Circle()
					.fill(Colors.luasGreen)
					.scaleEffect(isAnimating ? 1.5 : 1)
					.animation(standardAnimation)

				Circle()
					.stroke(Colors.luasRed, lineWidth: 3)
					.scaleEffect(isAnimating ? 2.0 : 1)
					.animation(slowAnimation)

			}.frame(width: CGFloat(20), height: CGFloat(20))
				.onAppear { self.isAnimating = true }
				.padding(25)
		}
	}

	fileprivate var standardAnimation: Animation {
		Animation
			.easeInOut(duration: 0.7)
			.repeatForever()
	}

	fileprivate var slowAnimation: Animation {
		Animation
			.easeInOut(duration: 1.4)
			.repeatForever()
	}
}
