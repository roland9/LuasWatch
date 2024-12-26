//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Foundation
import Testing

@testable import LuasKit2

@Test func createsRouteFromString() async throws {
  var route = Route(rawValue: "green")
  #expect(route == .green)

  route = Route(rawValue: "red")
  #expect(route == .red)

  route = Route(rawValue: "Green")
  #expect(route == .green)

  route = Route(rawValue: "anything")
  #expect(route == nil)
}

@Test func routeOtherReturnsExpectedValue() async throws {
  var route = Route.red
  #expect(route.other == .green)

  route = Route.green
  #expect(route.other == .red)
}
