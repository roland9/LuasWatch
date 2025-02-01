//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

struct LuasTextView: View {
  var text: String

  var body: some View {
    HStack {
      Spacer()
      Text(text)
        .font(.title2)
        .monospaced()
      Spacer()
    }
    .foregroundColor(.yellow)
    .timeTableStyle()
    .toolbar {
      ToolbarInactive()
    }
  }
}
