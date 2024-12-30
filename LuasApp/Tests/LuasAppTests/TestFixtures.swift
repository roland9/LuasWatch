//
//  Created by Roland Gropmair on 28/12/2024.
//

import CoreLocation

@testable import LuasAPI

let locationBluebell = CLLocation(
  latitude: CLLocationDegrees(53.3292817872831),
  longitude: CLLocationDegrees(-6.33382500275916)
)

let locationMarlborough = CLLocation(
  latitude: CLLocationDegrees(53.3492448734525),
  longitude: CLLocationDegrees(-6.25773158174389)
)

let stationBluebell = TrainStation(
  stationIdShort: "LUAS8",
  shortCode: "BLU",
  route: .red,
  name: "Bluebell",
  location: CLLocation(
    latitude: CLLocationDegrees(53.3292817872831),
    longitude: CLLocationDegrees(-6.33382500275916)),
  stationType: .twoway
)

let stationGreen = TrainStation(
  stationIdShort: "short id 1",
  shortCode: "short code 1",
  route: .green,
  name: "station name 1",
  location: locationMarlborough,
  stationType: .terminal
)

let stationHarcourt = TrainStation(
  stationIdShort: "LUAS25",
  shortCode: "HAR",
  route: .green,
  name: "Harcourt",
  location: CLLocation(
    latitude: CLLocationDegrees(53.3336246192981),
    longitude: CLLocationDegrees(-6.26273785213714)),
  stationType: .twoway
)

let stationRed = TrainStation(
  stationIdShort: "short id 2",
  shortCode: "short code 2",
  route: .red,
  name: "station name 2",
  location: locationBluebell,
  stationType: .terminal
)

let stationRedLongName = TrainStation(
  stationIdShort: "LUAS8",
  shortCode: "BLU",
  route: .red,
  name: "Bluebell Luas Stop long name",
  location: locationBluebell,
  stationType: .twoway
)

let trainRed1_outbound = Train(
  destination: "LUAS The Point", direction: "Outbound", dueTime: "Due")
let trainRed2_outbound = Train(
  destination: "LUAS The Point", direction: "Outbound", dueTime: "2")
let trainRed3_outbound = Train(
  destination: "LUAS Connolly", direction: "Outbound", dueTime: "5")
let trainRed4_outbound = Train(
  destination: "LUAS The Point", direction: "Outbound", dueTime: "7")
let trainRed5_outbound = Train(
  destination: "LUAS The Point", direction: "Outbound", dueTime: "9")
let trainRed6_outbound = Train(
  destination: "LUAS Connolly", direction: "outbound", dueTime: "11")
let trainRed7_outbound = Train(
  destination: "LUAS Connolly", direction: "outbound", dueTime: "15")

let trainRed1_inbound = Train(
  destination: "LUAS Tallaght", direction: "Inbound", dueTime: "Due")
let trainRed2_inbound = Train(
  destination: "LUAS Tallaght", direction: "Inbound", dueTime: "4")
let trainRed3_inbound = Train(
  destination: "LUAS Saggart", direction: "Inbound", dueTime: "5")
let trainRed4_inbound = Train(
  destination: "LUAS Tallaght", direction: "Inbound", dueTime: "7")
let trainRed5_inbound = Train(
  destination: "LUAS Saggart", direction: "Inbound", dueTime: "9")
let trainRed6_inbound = Train(
  destination: "LUAS Saggart", direction: "Inbound", dueTime: "12")
let trainRed7_inbound = Train(
  destination: "LUAS Saggart", direction: "Inbound", dueTime: "14")

let trainsRed_1_1 = TrainsByDirection(
  station: stationRed,
  inbound: [trainRed3_inbound],
  outbound: [trainRed2_outbound])
let trainsRed_2_1 = TrainsByDirection(
  station: stationRed,
  inbound: [trainRed1_inbound, trainRed3_inbound],
  outbound: [trainRed2_outbound])
let trainsRed_3_2 = TrainsByDirection(
  station: stationRedLongName,
  inbound: [trainRed1_inbound, trainRed2_inbound, trainRed3_inbound],
  outbound: [trainRed1_outbound, trainRed2_outbound])
let trainsRed_4_4 = TrainsByDirection(
  station: stationRed,
  inbound: [trainRed1_inbound, trainRed2_inbound, trainRed3_inbound, trainRed4_inbound],
  outbound: [trainRed1_outbound, trainRed2_outbound, trainRed3_outbound, trainRed4_outbound])
let trainsRed_0_4 = TrainsByDirection(
  station: stationRed,
  inbound: [],
  outbound: [trainRed1_outbound, trainRed2_outbound, trainRed3_outbound, trainRed4_outbound])
let trainsRed_7_7 = TrainsByDirection(
  station: stationRedLongName,
  inbound: [
    trainRed1_inbound, trainRed2_inbound, trainRed3_inbound, trainRed4_inbound, trainRed5_inbound,
    trainRed6_inbound, trainRed7_inbound,
  ],
  outbound: [
    trainRed1_outbound, trainRed2_outbound, trainRed3_outbound, trainRed4_outbound,
    trainRed5_outbound, trainRed6_outbound,
    trainRed7_outbound,
  ])
