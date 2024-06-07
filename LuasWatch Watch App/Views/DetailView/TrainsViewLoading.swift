//
//  Created by Roland Gropmair on 25/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct TrainsViewLoading: View {

    var body: some View {
        VStack {
            Spacer()
            Text(LuasStrings.trainsLoading)
                .font(.caption2)
                .monospaced()
                .foregroundColor(.yellow)
                .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}
