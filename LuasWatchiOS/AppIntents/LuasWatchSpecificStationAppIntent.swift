//
//  Created by Roland Gropmair on 07/06/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import AppIntents
import LuasAPI
import LuasApp

struct LuasWatchSpecificStationAppIntent: AppIntent {
  static var title: LocalizedStringResource = "LUAS Times for Station"

  static var description =
  IntentDescription("Shows due times of a specific LUAS stop.")

  @Parameter(title: "LUAS Stop", optionsProvider: LuasStopOptionsProvider())
  var luasStop: String

  @Parameter(title: "Train Direction (if Station has both)")
  var direction: DirectionEnum

  private struct LuasStopOptionsProvider: DynamicOptionsProvider {

    func results() async throws -> [String] {
      TrainStations()
        .allStations
        .map { $0.name }
        .sorted()   // we could group first by green/red but this might be more intuitive
    }
  }

  func perform() async throws -> some IntentResult & ReturnsValue<String> {

    // find station by name (parameter for our AppIntent)
    let station = TrainStations()
      .allStations
      .filter { $0.name == luasStop }
      .first

    // throw error if not found (that shouldn't happen actually)
    guard let station else { throw AppIntentError.stationNotFound(luasStop) }

    // call API to get due times & format output for human consumption (Siri might speak it)
    let output = await station.loadFromAPIAndFormat(direction: direction)

    return .result(value: output)
  }

  enum AppIntentError: Error {
    case stationNotFound(String)
  }
}

extension TrainStation {

  func loadFromAPIAndFormat(direction: DirectionEnum) async -> String {

    do {
      let api = LuasAPI(session: URLSession.shared)

      let trains = try await api.dueTimes(for: self)

      return trains.formatForShortcut(direction: direction.toLuasKitDirection)

    } catch {

      if let apiError = error as? APIError {

        //  TODO need to test this - does it say cryptic error message!
        switch apiError {
          case .noTrains:
            return LuasStrings.noTrains

          case .noTrainsButMessageFromAPI(let message):
            return message

          case .invalidXML(let message):
            return "Error reading server response"
        }
      } else {
        return "Error reading server response"
      }
    }
  }
}
