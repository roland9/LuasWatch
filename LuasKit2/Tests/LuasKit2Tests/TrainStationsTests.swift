//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Foundation
import Testing

@testable import LuasKit2

let stationGreen = TrainStation(
  stationIdShort: "short id 1",
  shortCode: "short code 1",
  route: .green,
  name: "station name 1",
  location: locationMarlborough,
  stationType: .terminal
)

let stationRed = TrainStation(
  stationIdShort: "short id 2",
  shortCode: "short code 2",
  route: .red,
  name: "station name 2",
  location: locationBluebell,
  stationType: .terminal
)

@Test func createsTrainStations() throws {

  let stations = TrainStations(stations: [stationGreen, stationRed])

  #expect(stations.greenLineStations == [stationGreen])
  #expect(stations.redLineStations == [stationRed])
}

@Test func trainStations_closestFromLocation() throws {

  let closeLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.00425,
    longitude: locationBluebell.coordinate.longitude + 0.005
  )
  let veryCloseLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.000425,
    longitude: locationBluebell.coordinate.longitude + 0.0005
  )
  let farAwayLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.425,
    longitude: locationBluebell.coordinate.longitude + 0.5
  )

  let stations = TrainStations(stations: [stationGreen, stationRed])

  #expect(stations.closestStation(from: locationBluebell) == stationRed)
  #expect(stations.closestStation(from: closeLocation) == stationRed)
  #expect(stations.closestStation(from: veryCloseLocation) == stationRed)
  #expect(stations.closestStation(from: locationMarlborough) == stationGreen)
  #expect(stations.closestStation(from: farAwayLocation) == nil)
}

@Test func trainStations_closestFromLocationRoute() throws {

  let closeLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.00425,
    longitude: locationBluebell.coordinate.longitude + 0.005
  )
  let veryCloseLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.000425,
    longitude: locationBluebell.coordinate.longitude + 0.0005
  )

  let stations = TrainStations(stations: [stationGreen, stationRed])

  #expect(stations.closestStation(from: closeLocation, route: .green) == stationGreen)
  #expect(stations.closestStation(from: closeLocation, route: .red) == stationRed)
  #expect(stations.closestStation(from: veryCloseLocation, route: .red) == stationRed)
}

@Test func trainStations_shortcode() throws {

  let stations = TrainStations(stations: [stationGreen, stationRed])

  #expect(stations.station(shortCode: "short code 1") == stationGreen)
  #expect(stations.station(shortCode: "short code 2") == stationRed)
  #expect(stations.station(shortCode: "something") == nil)
}
