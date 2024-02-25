//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct LinesView {
    var actionGreen: () -> Void
    var actionRed: () -> Void
}

extension LinesView: View {

    var body: some View {
        Button {
            actionGreen()
        } label: {
            // so we center the lineRowView
            HStack {
                Spacer()
                LineRow(route: .green)
                Spacer()
            }
        }
        .padding(.vertical, 8)

        Button {
            actionRed()
        } label: {
            HStack {
                Spacer()
                LineRow(route: .red)
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview("Lines") {
    List {
        Section {
            LinesView(actionGreen: {}, actionRed: {})
        } header: {
            Text("Lines")
                .font(.subheadline)
                .frame(minHeight: 40)
        }

    }
}
