//
//  Created by Roland Gropmair on 09/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation
import AppIntents
import CoreLocation

import LuasKitIOS

struct LuasTimesIntent: AppIntent {

    // TODO localize
    static var title: LocalizedStringResource = "Show departure times of closes LUAS station"

    static var description =
    IntentDescription("Determines user's location & shows the departure times of the closes LUAS stop.")

    func perform() async throws -> some IntentResult & ReturnsValue {

        let location = CLLocation(latitude: CLLocationDegrees(53.3643367750274),
                                  longitude: CLLocationDegrees(-6.28196929164465))

        let cabraStation = TrainStation(stationId: "gen:57102:3587:1",
                                        stationIdShort: "LUAS70",
                                        shortCode: "CAB",
                                        route: .green,
                                        name: "Cabra",
                                        location: location)

        let departureTimes = TrainsByDirection(trainStation: cabraStation,
                                                inbound: [Train(destination: "Sandyford", direction: "outbound", dueTime: "10 min")],
                                                outbound: [])



        return .result(value: departureTimes.shortcutOutput())
    }
}

extension TrainsByDirection {

    func shortcutOutput() -> String {
        var output = ""

        output += inbound
            .compactMap { "Luas to \($0.destination) in \($0.dueTime)." }
            .joined()

        output += outbound
            .compactMap { "Luas to \($0.destination) in \($0.dueTime)." }
            .joined()

        return output.count > 0 ? output : "No Luas trains found for station \(trainStation)"
    }
}
