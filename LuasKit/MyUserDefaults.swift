//
//  Created by Roland Gropmair on 06.08.20.
//  Copyright © 2020 mApps.ie. All rights reserved.
//

import Foundation

public struct MyUserDefaults {
    fileprivate static let userDefaultsKeySelectedStation = "SelectedStationIdShort"

    public static func userSelectedSpecificStation() -> TrainStation? {
        guard let stationId = UserDefaults.standard.string(forKey: userDefaultsKeySelectedStation),
            let station = TrainStations.sharedFromFile.stations.filter({ $0.stationIdShort == stationId }).first
        else { return nil }

        return station
    }

    public static func saveSelectedStation(_ station: TrainStation) {
        UserDefaults.standard.set(station.stationIdShort, forKey: userDefaultsKeySelectedStation)
    }

    public static func wipeUserSelectedStation() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKeySelectedStation)
    }
}
