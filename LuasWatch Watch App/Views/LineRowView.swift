//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import SwiftData
import LuasKit

struct LineRowView: View {

    let route: Route

    var body: some View {
        VStack {
            route.image
                .padding(5)
                .background(route.color)
                .cornerRadius(6)
            Text(route.text)
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
                return "Red Line Stations"
            case .green:
                return "Green Line Stations"
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
