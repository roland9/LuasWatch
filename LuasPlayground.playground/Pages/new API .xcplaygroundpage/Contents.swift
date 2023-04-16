import CoreLocation
import PlaygroundSupport

let userLocation = CLLocation(latitude: CLLocationDegrees(53.3163934083453), longitude: CLLocationDegrees(-6.25344151996991))

// swiftlint:disable:next line_length
// list from https://github.com/mcevoyki2/finalproject/blob/bf95904206107d45743c83bf7bc951c5c99f26b6/move-app/src/app/%2Bluas/enum/luas-stops.enum.ts
let station = TrainStation(stationId: "stationId",
						   stationIdShort: "LUAS28",
						   shortCode: "BEE",
						   route: .green,
						   name: "Beechwood",
						   location: userLocation)

let realAPI = LuasAPI(apiWorker: RealAPIWorker())
print(await realAPI.dueTimes(for: station))

let ranelaghMockAPI = LuasAPI(apiWorker: MockAPIWorker(scenario: .ranelaghTrains))
print(await ranelaghMockAPI.dueTimes(for: station))

let noTrainsMockAPI = LuasAPI(apiWorker: MockAPIWorker(scenario: .noTrainsButMessage))
print(await noTrainsMockAPI.dueTimes(for: station))

func print(_ result: Result<TrainsByDirection, APIError>) {

    switch result {
        case .failure(let apiError):
            print("\(#function): \(apiError)")

            switch apiError {
                case .noTrains(let message):
                    print(message)
                case .serverFailure(let message):
                    print(message)
                case .parserError(let parserError):
                    print(parserError)
            }

        case .success(let trains):
            print("\(#function): \(trains)")
    }
}
