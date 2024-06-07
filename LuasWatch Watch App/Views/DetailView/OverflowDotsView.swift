//
//  Created by Roland Gropmair on 01/03/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

struct OverflowDotsView: View {
    var body: some View {
        Text("...")
            .offset(CGSize(width: 0, height: -6))
            .frame(height: 1)
    }
}
