//
//  Created by Roland Gropmair on 06/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI

#warning("use swiftlint")

// @Observable does not work -  circular reference?
public class AppModel: ObservableObject {

    public init() {}

    // for previews
    public init(_ state: AppState) {
        self.appState = state
    }

    /// state machine, drives UI
    public enum AppState {

        case idle

        case gettingLocation
        case locationAuthorizationUnknown
        case errorGettingLocation(String)

        case errorGettingStation(String)  /// in case the user is too far away from Dublin area

        case loadingDueTimes(TrainStation, CLLocation)
        case errorGettingDueTimes(TrainStation, String)

        case foundDueTimes(TrainsByDirection, CLLocation)

        case updatingDueTimes(TrainsByDirection, CLLocation)

        public init(_ state: AppState) {
            self = state
        }
    }

    @Published public var appState: AppState = .idle

    // WIP do we need both - appMode & selectedStation??
    @Published public var selectedStation: TrainStation? {
        didSet {
            // save?

            NotificationCenter.default.post(Notification(name: Notification.Name("LuasWatch.RetriggerTimer")))
        }
    }

    public var changeable: AppStateChangeable?

    /// how user decided how current station should be determined
    public enum AppMode {

        /// need location
        case closest
        case closestOtherLine

        /// no location required, because user selected specific station (via various options)
        case favourite(TrainStation)
        case nearby(TrainStation)
        case specific(TrainStation)
        case recents(TrainStation)

        public var isSpecificStation: TrainStation? {
            switch self {

                case .closest, .closestOtherLine:
                    return nil
                case .favourite(let station), .nearby(let station), .specific(let station), .recents(let station):
                    return station
            }
        }
    }

//    @AppStorage("appMode") var appMode: AppMode = .closest
    @Published public var appMode: AppMode = .closest

    public func updateWithAnimation(to state: AppState) {
        withAnimation {
            DispatchQueue.main.async { [weak self] in
                self?.appState = state
            }
        }
    }
}

extension AppModel.AppMode: Equatable {}

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

/// WIP so we can support @AppStorage
//extension AppModel.AppMode: RawRepresentable {
//
//    public typealias RawValue = String
//
//    /// Failable Initalizer
//    public init?(rawValue: RawValue) {
//        switch rawValue {
//            case "closest":
//                self = .closest
//            case "closestOtherLine":
//                self = .closesOtherLine
//            case _ where rawValue.starts(with: "favourite "):
//                let shortCode = String(rawValue.dropFirst("favourite ".count))
//                let station = TrainStations.sharedFromFile.station(shortCode: shortCode)
////self =
//                break
//            default:
//                return nil
//        }
//    }
//
//    /// Backing raw value
//    public var rawValue: RawValue {
//        switch self {
//
//            case .closest:
//                return "closest"
//            case .closesOtherLine:
//                return "closestOtherLine"
//            case .favourite(let station):
//                return "favourite \(station.shortCode)"
//            case .nearby(let station):
//                return "nearby \(station.shortCode)"
//            case .specific(let station):
//                return "specific \(station.shortCode)"
//            case .recents(let station):
//                return "recents \(station.shortCode)"
//        }
//    }
//}
