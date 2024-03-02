//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct LineRow: View {

    let route: Route
    let isHighlighted: Bool
}

extension LineRow {

    var body: some View {
        HStack {
            Text(route.text)
                .fontWeight(isHighlighted ? .bold : .regular)

            Spacer()
            route.image
                .padding(5)
                .background(route.color)
                .cornerRadius(6)
        }
    }
}

extension Route {

    var image: Image {
        switch self {
            case .red:
                return Image(systemName: "arrow.up.arrow.down")
            case .green:
                return Image(systemName: "arrow.right.arrow.left")
        }
    }

    var text: String {
        switch self {
            case .red:
                return "Red line stations"
            case .green:
                return "Green line stations"
        }
    }

    var color: Color {
        switch self {
            case .red:
                return Color("luasRed")
            case .green:
                return Color("luasGreen")
        }
    }
}
