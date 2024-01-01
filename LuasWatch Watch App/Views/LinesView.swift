//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

struct LinesView: View {

    var body: some View {

        HStack {
            Text("Green Line")
            Spacer()
            Rectangle()
                .cornerRadius(3)
                .frame(width: 30, height: 20)
                .foregroundColor(Color("luasGreen"))
        }

        HStack {
            Text("Red Line")
            Spacer()
            Rectangle()
                .cornerRadius(3)
                .frame(width: 30, height: 20)
                .foregroundColor(Color("luasRed"))
        }
    }
}

#Preview("Lines") {
    List {
        Section {
            LinesView()
        } header: {
            Text("Lines")
                .font(.subheadline)
                .frame(minHeight: 40)

        }

    }
}
