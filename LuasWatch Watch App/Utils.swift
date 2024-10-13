//
//  Created by Roland Gröpmair on 02/07/16.
//  Copyright © 2016 mApps.ie. All rights reserved.
//

import Foundation

#if DEBUG
  // see http://stackoverflow.com/questions/6748087/xcode-test-vs-debug-preprocessor-macros
  func isRunningUnitTests() -> Bool {
    NSClassFromString("XCTestCase") != nil
  }
#endif
