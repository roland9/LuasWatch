//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct ToolbarInactive {
    // no properties
}

extension ToolbarInactive: ToolbarContent {

    var body: some ToolbarContent {

        ToolbarItemGroup(placement: .bottomBar) {

            /// Change direction
            Button {
                // nop
            } label: {
                Image(systemName: "arrow.left.arrow.right")
            }
            .disabled(true)

            /// Favourite
            Button {
                // nop
            } label: {
                Image(systemName: "heart")
            }
            .disabled(true)
        }
    }
}
