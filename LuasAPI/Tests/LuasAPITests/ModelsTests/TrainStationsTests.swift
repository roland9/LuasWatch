//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Testing

@testable import LuasAPI

struct TrainStationsTests {

  @Test func trainStations_createsTrainStations() throws {

    let stations = TrainStations(stations: [stationGreen, stationRed])

    #expect(stations.greenLineStations == [stationGreen])
    #expect(stations.redLineStations == [stationRed])
  }

  @Test func trainStations_initializer() async throws {

    let stations = TrainStations()

    #expect(stations.stations.count == 67)
    #expect(stations.greenLineStations.count == 35)
    #expect(stations.redLineStations.count == 32)
  }

  @Test func trainStations_initializer_url() async throws {

    let bundleURL = Bundle.module.url(forResource: "luasStops_test", withExtension: "json")!

    #expect(bundleURL.description.contains("LuasAPITests.xctest/"))
    #expect(bundleURL.description.hasSuffix("bundle/luasStops_test.json"))

    let stations = TrainStations(url: bundleURL)

    #expect(stations.stations.count == 67)
    #expect(stations.greenLineStations.count == 35)
    #expect(stations.redLineStations.count == 32)
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

    #expect(stations.closestStation(from: closeLocation,
                                    route: .green) == stationGreen)
    #expect(stations.closestStation(from: closeLocation,
                                    route: .red) == stationRed)
    #expect(stations.closestStation(from: veryCloseLocation,
                                    route: .red) == stationRed)
  }

  @Test func trainStations_shortcode() throws {

    let stations = TrainStations(stations: [stationGreen, stationRed])

    #expect(stations.station(shortCode: "short code 1") == stationGreen)
    #expect(stations.station(shortCode: "short code 2") == stationRed)
    #expect(stations.station(shortCode: "something") == nil)
  }
}
