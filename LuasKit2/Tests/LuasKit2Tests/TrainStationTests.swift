//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Foundation
import Testing

@testable import LuasKit2

let locationBluebell = CLLocation(
  latitude: CLLocationDegrees(53.3292817872831),
  longitude: CLLocationDegrees(-6.33382500275916)
)

let locationMarlborough = CLLocation(
  latitude: CLLocationDegrees(53.3492448734525),
  longitude: CLLocationDegrees(-6.25773158174389)
)

fileprivate let station = TrainStation(
  stationIdShort: "short id",
  shortCode: "short code",
  route: .green,
  name: "station name",
  location: locationBluebell,
  stationType: .oneway
)

@Test func buildsTrainStation() async throws {

  #expect(station.id == "short id")
  #expect(station.stationIdShort == "short id")
  #expect(station.shortCode == "short code")
  #expect(station.route == .green)
  #expect(station.name == "station name")
  #expect(station.location == locationBluebell)
  #expect(station.stationType == .oneway)

  #expect(
    station.description
      == "<short id> \"station name\"  (53.3292817872831/-6.33382500275916)  type: .oneway"
  )
}

@Test func trainStation_computedProperties() async throws {

  var station = TrainStation(
    stationIdShort: "short id",
    shortCode: "short code",
    route: .green,
    name: "station name",
    location: locationBluebell,
    stationType: .oneway
  )
  #expect(station.isFinalStop == false)
  #expect(station.allowsSwitchingDirection == false)

  station = TrainStation(
    stationIdShort: "short id",
    shortCode: "short code",
    route: .green,
    name: "station name",
    location: locationBluebell,
    stationType: .twoway
  )
  #expect(station.isFinalStop == false)
  #expect(station.allowsSwitchingDirection == true)

  station = TrainStation(
    stationIdShort: "short id",
    shortCode: "short code",
    route: .green,
    name: "station name",
    location: locationBluebell,
    stationType: .terminal
  )
  #expect(station.isFinalStop == true)
  #expect(station.allowsSwitchingDirection == false)
}

@Test func trainStation_distance() async throws {
  let station = TrainStation(
    stationIdShort: "short id",
    shortCode: "short code",
    route: .green,
    name: "station name",
    location: locationBluebell,
    stationType: .terminal
  )
  #expect(station.distance(from: locationMarlborough) == "6 km")

  let closeLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.00425,
    longitude: locationBluebell.coordinate.longitude + 0.005
  )
  #expect(station.distance(from: closeLocation) == "600 m")

  let veryCloseLocation = CLLocation(
    latitude: locationBluebell.coordinate.latitude + 0.000425,
    longitude: locationBluebell.coordinate.longitude + 0.0005
  )
  #expect(station.distance(from: veryCloseLocation) == nil)
}
