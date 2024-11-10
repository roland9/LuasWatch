//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#if DEBUG

  let genericAuthError = "Some generic auth error"

  #Preview("locAuth unknown") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(state: .locationAuthorizationUnknown))
  }

  #Preview("getloc") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(state: .gettingLocation))
  }

  #Preview("err - locDisabled") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(LuasStrings.locationServicesDisabled)))
  }

  #Preview("err - locDenied") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(LuasStrings.locationAccessDenied)))
  }

  // swiftlint:disable:next line_length
  let longGenericError =
    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

  #Preview("err - locManErr") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(longGenericError)))
  }

  #Preview("err - authErr") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(
            LuasStrings.gettingLocationAuthError(genericAuthError))))
  }

  #Preview("err - other") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(LuasStrings.gettingLocationOtherError)))
  }

  #Preview("err - far") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(LuasStrings.tooFarAway)))
  }

  #Preview("err - far larger") {
    LuasMainScreen()
      .environmentObject(
        makeAppModel(
          state: .errorGettingLocation(LuasStrings.locationServicesDisabled))
      )
      .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
  }

#endif
