//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct LinesView {
  @EnvironmentObject var appModel: AppModel

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
        LineRow(route: .green, isHighlighted: isHighlighted(for: .green))
        Spacer()
      }
    }
    .padding(.vertical, 8)

    Button {
      actionRed()
    } label: {
      HStack {
        Spacer()
        LineRow(route: .red, isHighlighted: isHighlighted(for: .red))
        Spacer()
      }
    }
    .padding(.vertical, 8)
  }

  private func isHighlighted(for route: Route) -> Bool {
    if case .specific(let specificStation) = appModel.appMode,
      specificStation.route == route
    {
      return true
    } else {
      return false
    }
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
