import CoreLocation

let allStations = TrainStations(fromFile: "luasStops")
let redStations = TrainStations.sharedFromFile.redLineStations.map { $0.name }
let greenStations = TrainStations.sharedFromFile.greenLineStations
let oneWayStations = TrainStations.sharedFromFile.stations
	.filter { $0.stationType == .oneway }
print(oneWayStations)

let finalStations = TrainStations.sharedFromFile.stations.filter { $0.stationType == .terminal }
print(finalStations)

oneWayStations.first!.isFinalStop
oneWayStations.first!.isOneWayStop

let userLocation = CLLocation(latitude: CLLocationDegrees(53.3163934083453), longitude: CLLocationDegrees(-6.25344151996991))
print("closest station: \(String(describing: allStations.closestStation(from: userLocation)))")
