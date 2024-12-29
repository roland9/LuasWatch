//
//  Created by Roland Gropmair on 26/12/2024.
//

import Foundation
import LuasAPI

struct LuasMockSession: URLSessionLoading {
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    ("someData".data(using: .utf8)!, URLResponse())
  }
}
