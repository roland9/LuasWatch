//
//  Created by Roland Gropmair on 26/12/2024.
//

import Foundation
import Testing
import CoreLocation

@testable import LuasKit2

let stationBluebell = TrainStation(
  stationIdShort: "LUAS8",
  shortCode: "BLU",
  route: .red,
  name: "Bluebell",
  location: CLLocation(
    latitude: CLLocationDegrees(53.3292817872831),
    longitude: CLLocationDegrees(-6.33382500275916)),
  stationType: .twoway
)

@Test func messageParsing_handlesMessageNoTrains() throws {

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

  let trainsByDirection = try APIParser.parse(xml: apiResponse, for: stationBluebell)

  #expect(trainsByDirection.inbound.count == 0)
  #expect(trainsByDirection.outbound.count == 0)
  #expect(trainsByDirection.message == "No service Stephen’s Green – Beechwood. See news")
}
