//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI
import SwiftData
import LuasKit

struct StationRowView: View {
    var station: TrainStation
    var action: () -> Void

    var body: some View {

        Button(
            action: { action() },
            label: {
                HStack {
                    Text(station.name)
                    Spacer()
                    Rectangle()
                        .cornerRadius(3)
                        .frame(width: 30, height: 20)
                        .foregroundColor(station.route == .red ?  Color("luasRed"): Color("luasGreen"))
                }
            }
        )
    }
}
