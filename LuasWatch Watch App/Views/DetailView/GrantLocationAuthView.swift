//
//  Created by Roland Gropmair on 01/07/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

struct GrantLocationAuthView: View {

  var didTapButton: () -> Void

  var body: some View {

    VStack {
      Text(LuasStrings.locationAuthorizationUnknown)
        .multilineTextAlignment(.center)
        .frame(idealHeight: .greatestFiniteMagnitude)
        .padding(.bottom)

      Button(
        action: {
          didTapButton()
        },
        label: {
          Text("OK")
        })
    }
  }
}
