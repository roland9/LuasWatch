//
//  Created by Roland Gropmair on 30/12/2024.
//

import Foundation
import Testing

@testable import LuasApp

struct AppModelCodableTests {

  //  @Test func appModelCodable_fromDecoder() throws {
  //    let appMode: AppMode = .closest
  //
  //    let storedAppMode = try? JSONDecoder().decode(
  //      AppMode.self, from: storedAppModeData)
  //  }

  @Test func appModelCodable_encode() throws {
    var appMode: AppMode = .closest
    var encoded = try JSONEncoder().encode(appMode)
    var decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closest)

    appMode = .closestOtherLine
    encoded = try JSONEncoder().encode(appMode)
    decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closestOtherLine)

    appMode = .favourite(stationBluebell)
    encoded = try JSONEncoder().encode(appMode)
    decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.favourite(stationBluebell))

    appMode = .nearby(stationHarcourt)
    encoded = try JSONEncoder().encode(appMode)
    decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.nearby(stationHarcourt))
  }
}
