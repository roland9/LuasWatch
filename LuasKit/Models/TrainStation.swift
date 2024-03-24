//
//  Created by Roland Gropmair on 23/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation

public struct TrainStation: CustomStringConvertible, Hashable, Identifiable {

    public var id: String {
        stationId
    }

    public enum StationType: String {
        case twoway, oneway, terminal
    }

    public let stationId: String  // not sure what that 'id' is for?
    public let stationIdShort: String  // that is the 'id' required for the API
    public let shortCode: String  // three-letter code, such as 'RAN'; for the XML API
    public let route: Route
    public let name: String
    public let location: CLLocation
    public let stationType: StationType

    public var description: String {
        return "\n<\(stationIdShort)> \(name)  (\(location.coordinate.latitude)/\(location.coordinate.longitude))  type \(stationType)"
    }

    public init(
        stationId: String, stationIdShort: String, shortCode: String,
        route: Route, name: String,
        location: CLLocation, stationType: StationType = .twoway
    ) {
        self.stationId = stationId
        self.stationIdShort = stationIdShort
        self.shortCode = shortCode
        self.route = route
        self.name = name
        self.location = location
        self.stationType = stationType
    }

    public var isFinalStop: Bool {
        stationType == .terminal
    }

    public var isOneWayStop: Bool {
        stationType == .oneway
    }

    public var allowsSwitchingDirection: Bool {
        stationType == .twoway
    }

    // will return nil if the distance is quite small, i.e. if the user is quite close to the station
    public func distance(from userLocation: CLLocation) -> String? {
        let minimumDistance = Measurement<UnitLength>(value: 200, unit: .meters)
        let distance = Measurement<UnitLength>(
            value: location.distance(from: userLocation),
            unit: .meters)

        guard distance > minimumDistance else { return nil }

        return Self.distanceFormatter.string(from: distance)
    }

    private static let distanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "en_IE")  // not correct we hard coded the locale here!
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .medium
        formatter.numberFormatter.usesSignificantDigits = true
        formatter.numberFormatter.maximumSignificantDigits = 1

        return formatter
    }()
}
