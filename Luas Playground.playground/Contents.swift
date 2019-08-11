import CoreLocation

//let allStations = TrainStations(fromFile: "luasStops")
//let userLocation = CLLocation(latitude: CLLocationDegrees(53.3163934083453), longitude: CLLocationDegrees(-6.25344151996991))
//
//print(allStations.closestStation(from: userLocation))

let stopName = "825GA00293"

LuasAPI.dueTime(for: stopName) { (result) in
	switch result {
	case .error(let message):
	print(message)
	case .success(let trains):
		print(trains)
	}
}

//LuasMockAPI.dueTime(for: stopName) { (result) in
//	switch result {
//	case .error(let message):
//		print(message)
//	case .success(let trains):
//		print(trains)
//	}
//}

//print(CLLocationManager.locationServicesEnabled())
