//
//  Created by Roland Gropmair on 17/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

extension Coordinator {

  func updateWithAnimation(to state: AppState) {

    withAnimation {
      if Thread.isMainThread {
        appModel.appState = state
      } else {
        DispatchQueue.main.async { [weak self] in
          self?.appModel.appState = state
        }
      }
    }
  }
}
