import CoreLocation
import PlaygroundSupport

let userLocation = CLLocation(latitude: CLLocationDegrees(53.3163934083453), longitude: CLLocationDegrees(-6.25344151996991))

// swiftlint:disable line_length
// list from https://github.com/mcevoyki2/finalproject/blob/bf95904206107d45743c83bf7bc951c5c99f26b6/move-app/src/app/%2Bluas/enum/luas-stops.enum.ts
let station = TrainStation(stationId: "stationId",
						   stationIdShort: "LUAS28",
						   shortCode: "BEE",
						   route: .green,
						   name: "Beechwood",
						   location: userLocation)

switch await LuasAPI2.dueTimes(for: station) {
    case .error(let message):
        print(message)
    case .success(let trains):
        print(trains)
}

switch await LuasMockAPI2.dueTimes(for: station) {
    case .error(let message):
        print(message)
    case .success(let trains):
        print(trains)
}

switch await LuasMockEmptyAPI2.dueTimes(for: station) {
    case .error(let message):
        print(message)
    case .success(let trains):
        print(trains)
}
