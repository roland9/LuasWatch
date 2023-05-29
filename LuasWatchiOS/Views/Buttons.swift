//
//  Created by Roland Gropmair on 29/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI

struct ModalButton: ButtonStyle {

    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}
