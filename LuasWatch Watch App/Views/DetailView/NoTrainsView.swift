//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct NoTrainsView: View {

    var body: some View {

        VStack {
            Spacer()

            Text(LuasStrings.noTrains)
                .font(.caption2)
                .monospaced()
                .foregroundColor(.yellow)
                .frame(maxWidth: .infinity)

            Spacer()
        }
    }
}
