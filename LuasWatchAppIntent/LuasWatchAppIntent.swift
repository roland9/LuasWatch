//
//  Created by Roland Gropmair on 10/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import AppIntents
import CoreLocation

import LuasKitIOS

enum DirectionEnum: String, CaseIterable, AppEnum {

    case both, inbound, outbound

    static var typeDisplayName: LocalizedStringResource = "Direction"

    public static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Direction of the train (for stations that have both)")

    public static var caseDisplayRepresentations: [DirectionEnum: DisplayRepresentation] {
        [.inbound: "inbound trains", .outbound: "outbound trains", .both: "both directions"]
    }
}

struct LuasWatchAppIntent: AppIntent {

    static var title: LocalizedStringResource = "Luas Times"

    static var description =
    IntentDescription("Shows departure times of a specific LUAS stop.")

    @Parameter(title: "LUAS Stop", optionsProvider: LuasStopOptionsProvider())
    var luasStop: String

    @Parameter(title: "Train Direction (if Station has both)")
    var direction: DirectionEnum

    private struct LuasStopOptionsProvider: DynamicOptionsProvider {

        func results() async throws -> [String] {
            TrainStations.sharedFromFile
                .stations
                .map { $0.name }
                .sorted()
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue {

        // find station by name (which is the parameter for our AppIntent)
        let station = TrainStations.sharedFromFile
            .stations
            .filter { $0.name == luasStop }
            .first

        // throw error if not found - shouldn't happen actually
        guard let station else { throw CoordinationError.stationNotFound(luasStop) }

        // call async API to get due times
        let output = await station.loadTrainTimesFromAPI(direction: direction)

        return .result(value: output)
    }

    enum CoordinationError: Error {
        case stationNotFound(String)
    }
}

extension TrainStation {

    internal func loadTrainTimesFromAPI(direction: DirectionEnum) async -> String {

        let result = await LuasAPI.dueTimes(for: self)

        switch result {
                // TODO need to test this!
            case .failure(let apiError):
                print("\(#function): \(apiError.localizedDescription)")
                return apiError.localizedDescription.count > 0 ? apiError.localizedDescription : LuasStrings.errorGettingDueTimes

            case .success(let trains):
                print("\(#function): \(trains)")
                return trains.shortcutOutput(direction)
        }
    }
}

extension TrainsByDirection {

    func shortcutOutput(_ direction: DirectionEnum) -> String {
        var output = ""

        if direction == .inbound || direction == .both {
            output += inbound
                .compactMap { $0.destinationDueTimeDescription + ".\n" }
                .joined()
        }

        if direction == .outbound || direction == .both {
            output += outbound
                .compactMap { $0.destinationDueTimeDescription + ".\n" }
                .joined()
        }

        return output.count > 0 ? output : "No trains found for \(trainStation.name) LUAS stop.\n"
    }
}
