//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct StationRow: View {

  var station: TrainStation
  var isHighlighted: Bool
  var action: () -> Void
}

extension StationRow {

  var body: some View {

    Button(
      action: { action() },
      label: {

        let dotColour = station.route == .red ? Color("luasRed") : Color("luasGreen")

        HStack {
          Text(station.name)
            .fontWeight(isHighlighted ? .bold : .regular)
          Spacer()
          Rectangle()
            .cornerRadius(3)
            .frame(width: 30, height: 20)
            .foregroundColor(dotColour)
        }
      }
    )
  }
}
