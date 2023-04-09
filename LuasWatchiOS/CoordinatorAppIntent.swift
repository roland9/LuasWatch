//
//  Created by Roland Gropmair on 09/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation

import LuasKitIOS

class CoordinatorAppIntent: NSObject {

    private var location: Location

    internal let appState: AppState
    internal var latestLocation: CLLocation?
    internal var trains: TrainsByDirection?

    init(appState: AppState,
         location: Location) {
        self.appState = appState
        self.location = location
    }

    func start() async -> String {
        // for now, let's use hard coded location
//        location.delegate = self
//
//        location.start()

        let location = CLLocation(latitude: CLLocationDegrees(53.3643367750274),
                                  longitude: CLLocationDegrees(-6.28196929164465))

        let cabraStation = TrainStation(stationId: "gen:57102:3587:1",
                                        stationIdShort: "LUAS70",
                                        shortCode: "CAB",
                                        route: .green,
                                        name: "Cabra",
                                        location: location)

        let output = await handleAppIntent(cabraStation, location)

        return output.shortcutOutput
    }
}
