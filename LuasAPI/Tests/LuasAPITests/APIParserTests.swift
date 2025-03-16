//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Foundation
import Testing

@testable import LuasAPI

struct APIParserTests {

  @Test func xmlAPIParser_handlesRanelaghTrains() throws {

    let trainsByDirection = try APIParser.parse(
      xml: APIResponseJSON.trainsRanelagh,
      for: stationBluebell
    )

    #expect(trainsByDirection.inbound.count == 2)
    #expect(
      trainsByDirection.inbound == [
        Train(
          destination: "Broombridge",
          direction: "Inbound",
          dueTime: "Due"
        ),
        Train(
          destination: "Broombridge",
          direction: "Inbound",
          dueTime: "5"
        )
      ]
    )

    #expect(trainsByDirection.outbound.count == 3)
    #expect(
      trainsByDirection.outbound == [
        Train(
          destination: "Bride's Glen",
          direction: "Outbound",
          dueTime: "7"
        ),
        Train(
          destination: "Sandyford",
          direction: "Outbound",
          dueTime: "9"
        ),
        Train(
          destination: "Bride's Glen",
          direction: "Outbound",
          dueTime: "15"
        )
      ]
    )
    #expect(trainsByDirection.message
        == "Green Line services operating normally")
  }

  @Test func xmlAPIParser_handlesNoTraingButMessage() throws {

    let trainsByDirection = try APIParser.parse(
      xml: APIResponseJSON.noTrainsWithMessage,
      for: stationBluebell
    )

    #expect(trainsByDirection.inbound.count == 0)
    #expect(trainsByDirection.outbound.count == 0)
    #expect(trainsByDirection.message
        == "Green Line services operating normally")
  }

  @Test func xmlAPIParser_handlesMessageNoTrainsWithApostrophe() throws {

    // Apr 2023: looks like they fixed the XML now, escaping the apostrophe, so this fix is not that urgent anymore:
    // <message>No service Stephen\'s Green - Beechwood. See news</message>

    let trainsByDirection = try APIParser.parse(
      xml: APIResponseJSON.noTrainsButMessageWithApostrophe,
      for: stationBluebell
    )

    #expect(trainsByDirection.inbound.count == 0)
    #expect(trainsByDirection.outbound.count == 0)
    #expect(trainsByDirection.message
        == "No service Stephen’s Green – Beechwood. See news")
  }

  @Test func xmlAPIParser_handlesNoTrainsNoMessage() throws {

    let trainsByDirection = try APIParser.parse(
      xml: APIResponseJSON.noTrainsNoMessage,
      for: stationBluebell
    )

    #expect(trainsByDirection.inbound.count == 0)
    #expect(trainsByDirection.outbound.count == 0)
    #expect(trainsByDirection.message
        == nil)
  }
}
