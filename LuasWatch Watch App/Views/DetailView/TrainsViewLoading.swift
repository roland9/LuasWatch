//
//  Created by Roland Gropmair on 25/05/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasApp

struct TrainsViewLoading: View {

  var body: some View {
    Text(LuasStrings.trainsLoading)
      .frame(minHeight: 90)
      .timeTableStyle()
  }
}
