//
//  Created by Roland Gropmair on 25/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasApp
import SwiftUI

struct TrainsViewLoading: View {

  var body: some View {
    Text(LuasStrings.trainsLoading)
      .frame(minHeight: 90)
      .timeTableStyle()
  }
}
