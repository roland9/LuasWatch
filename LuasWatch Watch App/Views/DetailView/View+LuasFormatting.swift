//
//  Created by Roland Gropmair on 24/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

extension View {

  func timeTableStyle() -> some View {
    self
      .frame(maxWidth: .infinity)
      .frame(minHeight: 90)
      .font(.caption2)
      .monospaced()
      .foregroundColor(.yellow)
      .padding(6)
      .background(.black)
      .border(.secondary).cornerRadius(2)
      .padding(4)
  }
}
