//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Testing

@testable import LuasAPI

fileprivate let station = TrainStation(
  stationIdShort: "short id",
  shortCode: "short code",
  route: .green,
  name: "station name",
  location: locationBluebell,
  stationType: .oneway
)

struct TrainStationTests {

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

    let veryCloseLocation = CLLocation(
      latitude: locationBluebell.coordinate.latitude + 0.000425,
      longitude: locationBluebell.coordinate.longitude + 0.0005
    )
    #expect(station.distance(from: veryCloseLocation) == nil)

    let closeLocation = CLLocation(
      latitude: locationBluebell.coordinate.latitude + 0.00425,
      longitude: locationBluebell.coordinate.longitude + 0.005
    )
    #expect(station.distance(from: closeLocation) == "600 m")

    let locationFarAway = CLLocation(
      latitude: stationHarcourt.location.coordinate.latitude + 0.0425,
      longitude: stationHarcourt.location.coordinate.longitude + 0.05
    )
    #expect(station.distance(from: locationFarAway) == "10 km")
  }

  @Test func trainStation_unknownStation() throws {
    let unknownStation = TrainStation(
      stationIdShort: "unknown",
      shortCode: "unknown",
      route: .green,
      name: "Unknown",
      location: CLLocation(
        latitude: CLLocationDegrees(53.3163934083453),
        longitude: CLLocationDegrees(-6.25344151996991))
    )

    #expect(unknownStation == TrainStation.unknown)
  }
}
