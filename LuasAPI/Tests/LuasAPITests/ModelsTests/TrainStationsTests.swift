//
//  Created by Roland Gropmair on 26/12/2024.
//

import CoreLocation
import Testing

@testable import LuasAPI

struct TrainStationsTests {

  @Test func trainStations_initializerLoadsFromBuiltinJSON() async throws {

    let stations = TrainStations()

    #expect(stations.allStations.count == 67)
    #expect(stations.greenLineStations.count == 35)
    #expect(stations.redLineStations.count == 32)
  }

  @Test func trainStations_createsTrainStations() throws {

    let stations = TrainStations(stations: [stationGreen, stationRed])

    #expect(stations.greenLineStations == [stationGreen])
    #expect(stations.redLineStations == [stationRed])
  }

  @Test func trainStations_initializer_url() async throws {

    let bundleURL = Bundle.module.url(forResource: "luasStops_test", withExtension: "json")!

    #expect(bundleURL.description.contains("LuasAPITests.xctest/"))
    #expect(bundleURL.description.hasSuffix("bundle/luasStops_test.json"))

    let stations = TrainStations(url: bundleURL)

    #expect(stations.allStations.count == 67)
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

  @Test func closestStations_returnsStationsRankedByDistance_redlineStations() async throws {
    let stations = TrainStations()
    let blueBell = stationBluebell
    let blackHorse = try #require(stations.station(shortCode: "BLA"))
    let kylemore = try #require(stations.station(shortCode: "KYL"))
    let drimnagh = try #require(stations.station(shortCode: "DRI"))
    let goldenBridge = try #require(stations.station(shortCode: "GOL"))

    let closestStations = stations.closestStationsSorted(from: blueBell.location)

    #expect(closestStations.count == 67)
    #expect(closestStations.prefix(5) == [
      blueBell,
      blackHorse,
      kylemore,
      drimnagh,
      goldenBridge
    ])
  }

  @Test func closestStations_returnsStationsRankedByDistance_cityCentre() async throws {
    let stations = TrainStations()
    let oConnellGPO = try #require(stations.station(shortCode: "OGP"))
    let abbeyStreet = try #require(stations.station(shortCode: "ABB"))
    let marlborough = try #require(stations.station(shortCode: "MAR"))
    let westmoreLand = try #require(stations.station(shortCode: "WES"))
    let oConnellUpper = try #require(stations.station(shortCode: "OUP"))

    let closestStations = stations.closestStationsSorted(from: oConnellGPO.location)

    #expect(closestStations.count == 67)
    #expect(closestStations.prefix(5) == [
      oConnellGPO,
      abbeyStreet,
      marlborough,
      westmoreLand,
      oConnellUpper
    ])
    #expect(closestStations.last!.shortCode == "BRI")
  }

  @Test func trainStations_shortcode() throws {

    let stations = TrainStations(stations: [stationGreen, stationRed])

    #expect(stations.station(shortCode: "short code 1") == stationGreen)
    #expect(stations.station(shortCode: "short code 2") == stationRed)
    #expect(stations.station(shortCode: "something") == nil)
  }
}
