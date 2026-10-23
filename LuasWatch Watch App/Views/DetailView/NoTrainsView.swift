//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasApp
import SwiftUI

struct NoTrainsView: View {

  var body: some View {
    Text(LuasStrings.noTrains)

    // note: don't add .timeTableStyle() here
    // we need it for combined DoubleTimetableView
  }
}
