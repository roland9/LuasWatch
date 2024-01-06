//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct LinesView: View {
    var actionRed: () -> Void
    var actionGreen: () -> Void

    var body: some View {
        Button {
            actionGreen()
        } label: {
            LineRowView(route: .green)
        }
        .padding(4)

        Button {
            actionRed()
        } label: {
            LineRowView(route: .red)
        }
        .padding(4)
    }
}

#Preview("Lines") {
    List {
        Section {
            LinesView(actionRed: {}, actionGreen: {})
        } header: {
            Text("Lines")
                .font(.subheadline)
                .frame(minHeight: 40)

        }

    }
}
