//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Testing

@testable import LuasAPI

struct RouteTests {

  @Test func route_createsRouteFromString() async throws {
    var route = Route(rawValue: "green")
    #expect(route == .green)

    route = Route(rawValue: "red")
    #expect(route == .red)

    route = Route(rawValue: "Green")
    #expect(route == .green)

    route = Route(rawValue: "anything")
    #expect(route == nil)
  }

  @Test func route_routeOtherReturnsExpectedValue() async throws {
    var route = Route.red
    #expect(route.other == .green)

    route = Route.green
    #expect(route.other == .red)
  }
}
