//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftUI

// @Observable does not work -  circular reference?
public class AppModel: ObservableObject {

    /// state machine, drives UI
    public enum AppState {

        case idle

        case gettingLocation
        case locationAuthorizationUnknown
        case errorGettingLocation(String)

        case errorGettingStation(String)
        /// in case the user is too far away from Dublin area

        case loadingDueTimes(TrainStation, CLLocation)
        case errorGettingDueTimes(TrainStation, String)

        case foundDueTimes(TrainsByDirection, CLLocation)

        case updatingDueTimes(TrainsByDirection, CLLocation)

        public init(_ state: AppState) {
            self = state
        }
    }

    /// how user decided how current station should be determined
    public enum AppMode: Equatable {

        /// need location
        case closest
        case closestOtherLine

        /// no location required, because user selected specific station (via various options)
        case favourite(TrainStation)
        case nearby(TrainStation)
        case specific(TrainStation)
        case recents(TrainStation)

        public var specificStation: TrainStation? {
            switch self {

                case .closest, .closestOtherLine:
                    return nil
                case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                    return station
            }
        }

        public var needsLocation: Bool {
            self == .closest || self == .closestOtherLine
        }
    }

    @Published public var appState: AppState = .idle

    @Published public var appMode: AppMode = .closest {
        didSet {
            do {
                let encoded = try JSONEncoder().encode(appMode)
                UserDefaults.standard.set(encoded, forKey: "AppMode")

                switch appMode {

                    case .closest, .closestOtherLine:
                        self.selectedStation = nil
                    case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                        self.selectedStation = station
                }
                NotificationCenter.default.post(Notification(name: Notification.Name("LuasWatch.RetriggerTimer")))

            } catch {
                myPrint("error encoding appMode \(error)")
            }
        }
    }

    // WIP do we need both - appMode & selectedStation??
    // don't need to save here, because we also set the appMode above - which gets saved
    // in fact, ideally we could get rid of the selectedStation - because it's part of the appMode??!!
    @Published public var selectedStation: TrainStation?

    @Published public var latestLocation: CLLocation?

    @Published public var allowStationTabviewUpdates: Bool = true
    
    public init() {
        if let storedAppModeData = UserDefaults.standard.object(forKey: "AppMode") as? Data,
            let storedAppMode = try? JSONDecoder().decode(AppMode.self, from: storedAppModeData)
        {
            self.appMode = storedAppMode

            switch storedAppMode {

                case .closest, .closestOtherLine:
                    self.selectedStation = nil
                case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                    self.selectedStation = station
            // we don't need to trigger here do we?
            //                    NotificationCenter.default.post(Notification(name: Notification.Name("LuasWatch.RetriggerTimer")))
            }

        } else {
            self.appMode = .closest
            self.selectedStation = nil
        }
    }

    // for previews
    public init(_ state: AppState) {
        self.appState = state
    }

    // that should be somewhere else
    public func updateWithAnimation(to state: AppState) {
        withAnimation {
            DispatchQueue.main.async { [weak self] in
                self?.appState = state
            }
        }
    }
}

extension AppModel.AppMode: Codable {

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

extension AppModel.AppState: CustomStringConvertible {

    public var description: String {
        switch self {

            case .idle:
                return "Idle"
            case .gettingLocation:
                return LuasStrings.gettingLocation
            case .locationAuthorizationUnknown:
                return LuasStrings.locationAuthorizationUnknown
            case .errorGettingLocation(let errorMessage):
                return errorMessage
            case .errorGettingStation:
                return LuasStrings.errorGettingStation
            case .loadingDueTimes(let trainStation, _):
                return LuasStrings.gettingDueTimes(trainStation)
            case .errorGettingDueTimes(_, let errorMessage):
                return errorMessage
            case .foundDueTimes(let trains, _):
                return LuasStrings.foundDueTimes(trains)
            case .updatingDueTimes(let trains, _):
                return LuasStrings.updatingDueTimes(trains)
        }
    }
}
