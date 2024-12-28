//
//  Created by Roland Gropmair on 28/12/2024.
//

import CoreLocation
import Testing

@testable import LuasKit2

struct DirectionTests {

  @Test func direction_description() throws {
    #expect(Direction.both.description == "Both directions")
    #expect(Direction.inbound.description == "Inbound")
    #expect(Direction.outbound.description == "Outbound")
  }

  @Test func direction_next() throws {
    #expect(Direction.both.next == Direction.inbound)
    #expect(Direction.inbound.next == Direction.outbound)
    #expect(Direction.outbound.next == Direction.both)
  }
}
