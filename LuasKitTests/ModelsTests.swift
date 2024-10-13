//
//  Created by Roland Gropmair on 10/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation
import XCTest

@testable import LuasKit

// this test class is shared between LuasKitTests and the WatchKitExtensionTests

class ModelsTests: XCTestCase {

  func testDueTimeDescription() {

    let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "DUE")
    let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
    let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

    let trains = TrainsByDirection(
      trainStation: stationBluebell,
      inbound: [train3],
      outbound: [train1, train2])

    XCTAssertEqual(trains.inbound.count, 1)
    XCTAssertEqual(trains.inbound[0].dueTimeDescription, "Sandyford: 12 mins")

    XCTAssertEqual(trains.outbound.count, 2)
    XCTAssertEqual(trains.outbound[0].dueTimeDescription, "Broombridge: Due")
    XCTAssertEqual(trains.outbound[1].dueTimeDescription, "Broombridge: 9 mins")
  }

  func testDestinationDueTimeDescription() {
    let train1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "DUE")
    let train2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
    let train3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

    let trains = TrainsByDirection(
      trainStation: stationBluebell,
      inbound: [train3],
      outbound: [train1, train2])

    XCTAssertEqual(trains.inbound.count, 1)
    XCTAssertEqual(trains.inbound[0].destinationDueTimeDescription, "Luas to LUAS Sandyford in 12")

    XCTAssertEqual(trains.outbound.count, 2)
    XCTAssertEqual(
      trains.outbound[0].destinationDueTimeDescription, "Luas to LUAS Broombridge is Due")
    XCTAssertEqual(
      trains.outbound[1].destinationDueTimeDescription, "Luas to LUAS Broombridge in 9")
  }

  func testIsFinalStop() {
    XCTAssertFalse(TrainStations.sharedFromFile.station(named: "Harcourt").isFinalStop)
    XCTAssertTrue(TrainStations.sharedFromFile.station(named: "Broombridge").isFinalStop)
  }

  func testGreenLineStations() {
    XCTAssertEqual(TrainStations.sharedFromFile.greenLineStations.count, 35)
  }

  func testRedLineStations() {
    XCTAssertEqual(TrainStations.sharedFromFile.redLineStations.count, 32)
  }

  func testClosestStation() {
    let allStations = TrainStations(stations: [stationBluebell, stationHarcourt])

    var location = CLLocation(
      latitude: CLLocationDegrees(53.32928178728), longitude: CLLocationDegrees(-6.333825002759))
    XCTAssertEqual(allStations.closestStation(from: location)!.name, "Bluebell")

    location = CLLocation(latitude: CLLocationDegrees(53.329), longitude: CLLocationDegrees(-6.333))
    XCTAssertEqual(allStations.closestStation(from: location)!.name, "Bluebell")

    location = CLLocation(latitude: CLLocationDegrees(53.1), longitude: CLLocationDegrees(-6.333))
    XCTAssertNil(allStations.closestStation(from: location))

    location = CLLocation(latitude: CLLocationDegrees(53.329), longitude: CLLocationDegrees(-6.333))
    XCTAssertEqual(allStations.closestStation(from: location, route: .red)!.name, "Bluebell")
    XCTAssertEqual(allStations.closestStation(from: location, route: .green)!.name, "Harcourt")
  }

  func testDistanceFromUserLocation() {
    let locationNearHarcourt =
      CLLocation(
        latitude: stationHarcourt.location.coordinate.latitude + 0.001,
        longitude: stationHarcourt.location.coordinate.longitude + 0.001)

    XCTAssertEqual(stationHarcourt.distance(from: locationNearHarcourt), nil)

    let locationFurtherAway =
      CLLocation(
        latitude: stationHarcourt.location.coordinate.latitude + 0.00425,
        longitude: stationHarcourt.location.coordinate.longitude + 0.005)

    XCTAssertEqual(stationHarcourt.distance(from: locationFurtherAway), "600 m")

    let locationFarAway =
      CLLocation(
        latitude: stationHarcourt.location.coordinate.latitude + 0.0425,
        longitude: stationHarcourt.location.coordinate.longitude + 0.05)

    XCTAssertEqual(stationHarcourt.distance(from: locationFarAway), "6 km")
  }

  func testShortcutOutput() {

    let trains = TrainsByDirection(
      trainStation: stationHarcourt,
      inbound: [
        Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due"),
        Train(destination: "Broombridge", direction: "Inbound", dueTime: "12"),
      ],

      outbound: [
        Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "7"),
        Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "14"),
      ],
      message: "Phibsborough lift works until 28/04/23. See news.")

    let output = trains.shortcutOutput(direction: .both)
    let expected =
      """
      Luas to Broombridge is Due.
      Luas to Broombridge in 12.
      Luas to Bride's Glen in 7.
      Luas to Bride's Glen in 14.

      """

    XCTAssertEqual(expected, output)
  }

  func testHasOverflow_noInbound_noOutbound_returns_InboundFalse_OutboundSmallAndLarge_false() {

    let trains = TrainsByDirection(
      trainStation: stationHarcourt,
      inbound: [],
      outbound: [])

    XCTAssertEqual(trains.inboundHasOverflowSmall, false)
    XCTAssertEqual(trains.outboundHasOverflowSmall, false)
    XCTAssertEqual(trains.inboundNoOverflowSmall, [])
    XCTAssertEqual(trains.outboundNoOverflowSmall, [])

    XCTAssertEqual(trains.inboundHasOverflowLarge, false)
    XCTAssertEqual(trains.outboundHasOverflowLarge, false)
    XCTAssertEqual(trains.inboundNoOverflowLarge, [])
    XCTAssertEqual(trains.outboundNoOverflowLarge, [])
  }

  func
    testHasOverflow_threeInbound_threeOutbound_returns_InboundOutboundSmall_false_InbountLarge_false()
  {

    let train = Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due")
    let trains = TrainsByDirection(
      trainStation: stationHarcourt,
      inbound: [train, train, train],
      outbound: [train, train, train])

    XCTAssertEqual(trains.inboundHasOverflowSmall, false)
    XCTAssertEqual(trains.outboundHasOverflowSmall, false)
    XCTAssertEqual(trains.inboundNoOverflowSmall, [train, train, train])
    XCTAssertEqual(trains.outboundNoOverflowSmall, [train, train, train])

    XCTAssertEqual(trains.inboundHasOverflowLarge, false)
    XCTAssertEqual(trains.outboundHasOverflowLarge, false)
    XCTAssertEqual(trains.inboundNoOverflowLarge, [train, train, train])
    XCTAssertEqual(trains.outboundNoOverflowLarge, [train, train, train])
  }

  func
    testHasOverflow_fourInbound_fourOutbound_returns_InboundOutboundSmall_true_InbountOutboundLarge_false()
  {

    let train1 = Train(destination: "Broombridge1", direction: "Inbound", dueTime: "Due")
    let train2 = Train(destination: "Broombridge2", direction: "Inbound", dueTime: "Due")
    let train3 = Train(destination: "Broombridge3", direction: "Inbound", dueTime: "Due")
    let train4 = Train(destination: "Broombridge4", direction: "Inbound", dueTime: "Due")

    let trains = TrainsByDirection(
      trainStation: stationHarcourt,
      inbound: [train1, train2, train3, train4],
      outbound: [train1, train2, train3, train4])

    XCTAssertEqual(trains.inboundHasOverflowSmall, true)
    XCTAssertEqual(trains.outboundHasOverflowSmall, true)
    XCTAssertEqual(trains.inboundNoOverflowSmall, [train1, train2, train3])
    XCTAssertEqual(trains.outboundNoOverflowSmall, [train1, train2, train3])

    XCTAssertEqual(trains.inboundHasOverflowLarge, false)
    XCTAssertEqual(trains.outboundHasOverflowLarge, false)
    XCTAssertEqual(trains.inboundNoOverflowLarge, [train1, train2, train3, train4])
    XCTAssertEqual(trains.outboundNoOverflowLarge, [train1, train2, train3, train4])
  }

  func
    testHasOverflow_sevenInbound_sevenOutbound_returns_InboundOutboundSmall_true_InbountOutboundLarge_true()
  {

    let train1 = Train(destination: "Broombridge1", direction: "Inbound", dueTime: "Due")
    let train2 = Train(destination: "Broombridge2", direction: "Inbound", dueTime: "Due")
    let train3 = Train(destination: "Broombridge3", direction: "Inbound", dueTime: "Due")
    let train4 = Train(destination: "Broombridge4", direction: "Inbound", dueTime: "Due")
    let train5 = Train(destination: "Broombridge5", direction: "Inbound", dueTime: "Due")
    let train6 = Train(destination: "Broombridge6", direction: "Inbound", dueTime: "Due")
    let train7 = Train(destination: "Broombridge7", direction: "Inbound", dueTime: "Due")

    let trains = TrainsByDirection(
      trainStation: stationHarcourt,
      inbound: [train1, train2, train3, train4, train5, train6, train7],
      outbound: [train1, train2, train3, train4, train5, train6, train7])

    XCTAssertEqual(trains.inboundHasOverflowSmall, true)
    XCTAssertEqual(trains.outboundHasOverflowSmall, true)
    XCTAssertEqual(trains.inboundNoOverflowSmall, [train1, train2, train3])
    XCTAssertEqual(trains.outboundNoOverflowSmall, [train1, train2, train3])

    XCTAssertEqual(trains.inboundHasOverflowLarge, true)
    XCTAssertEqual(trains.outboundHasOverflowLarge, true)
    XCTAssertEqual(trains.inboundNoOverflowLarge, [train1, train2, train3, train4, train5, train6])
    XCTAssertEqual(
      trains.outboundNoOverflowLarge, [train1, train2, train3, train4, train5, train6])
  }
}
