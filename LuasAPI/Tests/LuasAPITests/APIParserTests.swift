//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Foundation
import Testing

@testable import LuasAPI

struct APIParserTests {

  @Test func xmlAPIParser_handlesMessageNoTrainsWithApostrophe() throws {

    // Apr 2023: looks like they fixed the XML now, escaping the apostrophe, so this fix is not that urgent anymore:
    // <message>No service Stephen\'s Green - Beechwood. See news</message>

    let apiResponse = """
      <stopInfo created=\"2023-04-15T23:27:12\" stop=\"Beechwood\" stopAbv=\"BEE\">
          <message>No service Stephen’s Green – Beechwood. See news</message>
          <direction name=\"Inbound\">
              <tram destination=\"See news for information\" dueMins=\"\" />
          </direction>
          <direction name=\"Outbound\">
              <tram destination=\"See news for information\" dueMins=\"\" />
          </direction>
      </stopInfo>
      """.data(using: .utf8)!

    let trainsByDirection = try APIParser.parse(
      xml: apiResponse, for: stationBluebell)

    #expect(trainsByDirection.inbound.count == 0)
    #expect(trainsByDirection.outbound.count == 0)
    #expect(trainsByDirection.message
        == "No service Stephen’s Green – Beechwood. See news")
  }

  @Test func xmlAPIParser_handlesRanelaghTrains() throws {
    let apiResponse = """
      <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
          <message>Green Line services operating normally</message>
          <direction name="Inbound">
              <tram dueMins="Due" destination="Broombridge" />
          </direction>
          <direction name="Inbound">
              <tram dueMins="5" destination="Broombridge" />
          </direction>
          <direction name="Outbound">
              <tram dueMins="7" destination="Bride's Glen" />
          </direction>
          <direction name="Outbound">
              <tram dueMins="9" destination="Sandyford" />
          </direction>
          <direction name="Outbound">
              <tram dueMins="15" destination="Bride's Glen" />
          </direction>
      </stopInfo>
      """.data(using: .utf8)!

    let trainsByDirection = try APIParser.parse(
      xml: apiResponse, for: stationBluebell)

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
    let apiResponse = """
      <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
          <message>Green Line services operating normally</message>
          <direction name="Inbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
          <direction name="Outbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
      </stopInfo>
      """.data(using: .utf8)!

    let trainsByDirection = try APIParser.parse(
      xml: apiResponse, for: stationBluebell)

    #expect(trainsByDirection.inbound.count == 0)
    #expect(trainsByDirection.outbound.count == 0)
    #expect(trainsByDirection.message
        == "Green Line services operating normally")
  }

  @Test func xmlAPIParser_handlesNoTrainsNoMessage() throws {
    let apiResponse = """
      <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
          <direction name="Inbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
          <direction name="Outbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
      </stopInfo>
      """.data(using: .utf8)!

    let trainsByDirection = try APIParser.parse(
      xml: apiResponse, for: stationBluebell)

    #expect(trainsByDirection.inbound.count == 0)
    #expect(trainsByDirection.outbound.count == 0)
    #expect(trainsByDirection.message
        == nil)
  }
}
