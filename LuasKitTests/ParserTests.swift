//
//  Created by Roland Gropmair on 29/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import XCTest

@testable import LuasKit

class ParserTests: XCTestCase {

    func testMessageParsing() throws {

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

        XCTAssertEqual(trainsByDirection.inbound.count, 0)
        XCTAssertEqual(trainsByDirection.outbound.count, 0)
        XCTAssertEqual(trainsByDirection.message, "No service Stephen’s Green – Beechwood. See news")
    }
}
