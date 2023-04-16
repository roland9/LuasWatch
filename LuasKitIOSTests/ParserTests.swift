//
//  Created by Roland Gropmair on 15/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import XCTest

@testable import LuasKitIOS

class ParserTests: XCTestCase {

    func testMessageParsing() throws {

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
