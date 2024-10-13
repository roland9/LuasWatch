//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

struct DueView: View {
  let destination: String
  let due: String
}

extension DueView {

  var body: some View {

    HStack {
      Text(destination)
        .font(.caption2)
        .monospaced()
      Spacer()
      Text(due)
        .font(.caption2)
        .monospaced()
    }
    .foregroundColor(.yellow)
  }
}
