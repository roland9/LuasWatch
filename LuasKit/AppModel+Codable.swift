//
//  Created by Roland Gropmair on 05/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

extension AppMode: Codable {

    // https://stackoverflow.com/questions/69979095/codable-enum-with-arguments-and-fails-at-compile-time

    private enum CodingBase: String, Codable {
        case closest
        case closestOtherLine
        case favourite  // (TrainStation)
        case nearby  // (TrainStation)
        case specific  // (TrainStation)
        case recents  // (TrainStation)
    }

    private enum CodingKeys: String, CodingKey {
        case base
        case stationValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(CodingBase.self, forKey: .base)

        switch base {

            case .closest:
                self = .closest
            case .closestOtherLine:
                self = .closestOtherLine
            case .favourite:
                let shortCode = try container.decode(String.self, forKey: .stationValue)
                if let station = TrainStations.sharedFromFile.station(shortCode: shortCode) {
                    self = .favourite(station)
                } else {
                    self = .closest
                }
            case .nearby:
                let shortCode = try container.decode(String.self, forKey: .stationValue)
                if let station = TrainStations.sharedFromFile.station(shortCode: shortCode) {
                    self = .nearby(station)
                } else {
                    self = .closest
                }
            case .specific:
                let shortCode = try container.decode(String.self, forKey: .stationValue)
                if let station = TrainStations.sharedFromFile.station(shortCode: shortCode) {
                    self = .specific(station)
                } else {
                    self = .closest
                }
            case .recents:
                let shortCode = try container.decode(String.self, forKey: .stationValue)
                if let station = TrainStations.sharedFromFile.station(shortCode: shortCode) {
                    self = .recents(station)
                } else {
                    self = .closest
                }

        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .closest:
                try container.encode(CodingBase.closest, forKey: .base)
            case .closestOtherLine:
                try container.encode(CodingBase.closestOtherLine, forKey: .base)
            case .favourite(let station):
                try container.encode(CodingBase.favourite, forKey: .base)
                try container.encode(station.shortCode, forKey: .stationValue)
            case .nearby(let station):
                try container.encode(CodingBase.nearby, forKey: .base)
                try container.encode(station.shortCode, forKey: .stationValue)
            case .specific(let station):
                try container.encode(CodingBase.specific, forKey: .base)
                try container.encode(station.shortCode, forKey: .stationValue)
            case .recents(let station):
                try container.encode(CodingBase.recents, forKey: .base)
                try container.encode(station.shortCode, forKey: .stationValue)
        }
    }
}
