//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

struct LuasTextView: View {

  var text: String

  var body: some View {
    Text(text)
      .timeTableStyle()
  }
}
