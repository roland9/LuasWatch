//
//  Created by Roland Gropmair on 10/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation
import LuasKit

extension TrainStations {
  func station(named: String) -> TrainStation {
    stations.filter({ $0.name == named }).first!
  }
}

let location = CLLocation(latitude: CLLocationDegrees(1.1), longitude: CLLocationDegrees(1.2))

let stationBluebell = TrainStation(
  stationId: "822GA00360",
  stationIdShort: "LUAS8",
  shortCode: "BLU",
  route: .red,
  name: "Bluebell",
  location: CLLocation(
    latitude: CLLocationDegrees(53.3292817872831),
    longitude: CLLocationDegrees(-6.33382500275916)))

let stationHarcourt = TrainStation(
  stationId: "822GA00440",
  stationIdShort: "LUAS25",
  shortCode: "HAR",
  route: .green,
  name: "Harcourt",
  location: CLLocation(
    latitude: CLLocationDegrees(53.3336246192981),
    longitude: CLLocationDegrees(-6.26273785213714)))

let trainRed1 = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "Due")
let trainRed2 = Train(destination: "LUAS Tallaght", direction: "Outbound", dueTime: "9")
let trainRed3 = Train(destination: "LUAS Connolly", direction: "Inbound", dueTime: "12")

let stationRed = TrainStation(
  stationId: "stationId",
  stationIdShort: "LUAS8",
  shortCode: "BLU",
  route: .red,
  name: "Bluebell",
  location: location)

let trainsRed_1_1 = TrainsByDirection(
  trainStation: stationRed,
  inbound: [trainRed3],
  outbound: [trainRed2])
let trainsRed_2_1 = TrainsByDirection(
  trainStation: stationRed,
  inbound: [trainRed1, trainRed3],
  outbound: [trainRed2])
let trainsRed_3_2 = TrainsByDirection(
  trainStation: stationRed,
  inbound: [trainRed1, trainRed2, trainRed3],
  outbound: [trainRed1, trainRed2])
let trainsRed_4_4 = TrainsByDirection(
  trainStation: stationRed,
  inbound: [trainRed1, trainRed2, trainRed3, trainRed3],
  outbound: [trainRed1, trainRed2, trainRed3, trainRed3])
