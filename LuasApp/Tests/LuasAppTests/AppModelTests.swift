//
//  Created by Roland Gropmair on 30/12/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import Testing

@testable import LuasApp

struct AppModelTests {

  @Test func appModel_appStateIdleAfterInstantiation() throws {
    let model = AppModel()
    #expect(model.appState == .idle)
  }

  @Test func appModel_appModeClosestAfterInstantiation() throws {
    UserDefaults.standard.removeObject(forKey: "AppMode")

    let model = AppModel()
    #expect(model.appMode == .closest)
  }

  /// WIP we should inject UserDefaults and  NotificationCenter
  ///
  @Test func appModel_appStateDidSet() throws {
    let model = AppModel()

    model.appMode = .closest
    #expect(model.selectedStation == nil)

    model.appMode = .closestOtherLine
    #expect(model.selectedStation == nil)

    model.appMode = .favourite(stationBluebell)
    #expect(model.selectedStation == stationBluebell)

    model.appMode = .nearby(stationGreen)
    #expect(model.selectedStation == stationGreen)

    model.appMode = .specific(stationHarcourt)
    #expect(model.selectedStation == stationHarcourt)

    model.appMode = .recents(stationRedLongName)
    #expect(model.selectedStation == stationRedLongName)
  }

  @Test func appModel_appStateHighlightedStation() throws {
    let model = AppModel()

    model.appMode = .closest
    #expect(model.highlightedStation == nil)

    model.appMode = .specific(stationBluebell)
    #expect(model.highlightedStation == stationBluebell)
  }
}
