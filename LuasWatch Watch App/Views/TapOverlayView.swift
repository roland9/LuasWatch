//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI

extension LuasView {

    @ViewBuilder
    internal func tapOverlayView() -> some View {

        if let text = overlayTextAfterTap {
            overlayView(text)
        }
    }

    @ViewBuilder
    internal func overlayView(_ text: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black).opacity(0.82)
            VStack {
                Text(text)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
        .offset(y: 40)
        .frame(minHeight: 20, maxHeight: 240)
        .opacity(overlayTextViewOpacity)
        .onAppear {
            withAnimation(Animation.easeOut.delay(1.5)) {
                overlayTextViewOpacity = 0.0
            }

            // a bit ugly: reset so we're ready to show if user taps again
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                overlayTextAfterTap = nil
                overlayTextViewOpacity = 1.0
            }
        }
    }
}
