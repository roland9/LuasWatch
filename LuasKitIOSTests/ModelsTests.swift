//
//  Created by Roland Gropmair on 10/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import XCTest
import CoreLocation

@testable import LuasKitIOS

class ModelsTests: XCTestCase {

    func testShortcutOutput() {

        let trains =
        TrainsByDirection(trainStation: stationHarcourt,
                          inbound: [Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due"),
                                    Train(destination: "Broombridge", direction: "Inbound", dueTime: "12")],

                          outbound: [Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "7"),
                                     Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "14")],
                          message: "Phibsborough lift works until 28/04/23. See news.")

        let output = trains.shortcutOutput()
        let expected =
            """
            Bride's Glen in 7.
            Bride's Glen in 14.

            """

        XCTAssertEqual(expected, output)
    }
}
