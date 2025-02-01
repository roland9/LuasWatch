//
//  Created by Roland Gropmair on 24/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

extension View {

  func timeTableStyle() -> some View {
    self
      .frame(height: 200.0)
      .padding(16)
      .background(.black)
      .border(.secondary).cornerRadius(2)
      .padding(14)
  }
}
