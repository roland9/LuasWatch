//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import CoreLocation
import LuasKit
import SwiftUI

#if DEBUG

    let locationBluebell = CLLocation(
        latitude: CLLocationDegrees(53.3292817872831),
        longitude: CLLocationDegrees(-6.33382500275916))

    let userLocation = CLLocation(
        latitude: locationBluebell.coordinate.latitude + 0.00425,
        longitude: locationBluebell.coordinate.longitude + 0.005)

    private let stationRed = TrainStation(
        stationId: "stationId",
        stationIdShort: "LUAS8",
        shortCode: "BLU",
        route: .red,
        name: "Bluebell",
        location: locationBluebell)

    private let stationRedLongName = TrainStation(
        stationId: "stationId",
        stationIdShort: "LUAS8",
        shortCode: "BLU",
        route: .red,
        name: "Bluebell Luas Stop long name",
        location: locationBluebell)

    private let trainRed1_outbound = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "Due")
    private let trainRed2_outbound = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "2")
    private let trainRed3_outbound = Train(destination: "LUAS Connolly", direction: "Outbound", dueTime: "5")
    private let trainRed4_outbound = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "7")
    private let trainRed5_outbound = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "9")
    private let trainRed6_outbound = Train(destination: "LUAS Connolly", direction: "outbound", dueTime: "11")
    private let trainRed7_outbound = Train(destination: "LUAS Connolly", direction: "outbound", dueTime: "15")

    private let trainRed1_inbound = Train(destination: "LUAS Tallaght", direction: "Inbound", dueTime: "Due")
    private let trainRed2_inbound = Train(destination: "LUAS Tallaght", direction: "Inbound", dueTime: "4")
    private let trainRed3_inbound = Train(destination: "LUAS Saggart", direction: "Inbound", dueTime: "5")
    private let trainRed4_inbound = Train(destination: "LUAS Tallaght", direction: "Inbound", dueTime: "7")
    private let trainRed5_inbound = Train(destination: "LUAS Saggart", direction: "Inbound", dueTime: "9")
    private let trainRed6_inbound = Train(destination: "LUAS Saggart", direction: "Inbound", dueTime: "12")
    private let trainRed7_inbound = Train(destination: "LUAS Saggart", direction: "Inbound", dueTime: "14")

    let trainsRed_1_1 = TrainsByDirection(
        trainStation: stationRed,
        inbound: [trainRed3_inbound],
        outbound: [trainRed2_outbound])
    let trainsRed_2_1 = TrainsByDirection(
        trainStation: stationRed,
        inbound: [trainRed1_inbound, trainRed3_inbound],
        outbound: [trainRed2_outbound])
    let trainsRed_3_2 = TrainsByDirection(
        trainStation: stationRedLongName,
        inbound: [trainRed1_inbound, trainRed2_inbound, trainRed3_inbound],
        outbound: [trainRed1_outbound, trainRed2_outbound])
    let trainsRed_4_4 = TrainsByDirection(
        trainStation: stationRed,
        inbound: [trainRed1_inbound, trainRed2_inbound, trainRed3_inbound, trainRed4_inbound],
        outbound: [trainRed1_outbound, trainRed2_outbound, trainRed3_outbound, trainRed4_outbound])
    let trainsRed_0_4 = TrainsByDirection(
        trainStation: stationRed,
        inbound: [],
        outbound: [trainRed1_outbound, trainRed2_outbound, trainRed3_outbound, trainRed4_outbound])
    let trainsRed_7_7 = TrainsByDirection(
        trainStation: stationRedLongName,
        inbound: [
            trainRed1_inbound, trainRed2_inbound, trainRed3_inbound, trainRed4_inbound, trainRed5_inbound, trainRed6_inbound, trainRed7_inbound,
        ],
        outbound: [
            trainRed1_outbound, trainRed2_outbound, trainRed3_outbound, trainRed4_outbound, trainRed5_outbound, trainRed6_outbound,
            trainRed7_outbound,
        ])

    let stationGreen = TrainStation(
        stationId: "stationId",
        stationIdShort: "LUAS69",
        shortCode: "PHI",
        route: .green,
        name: "Phibsboro",
        location: locationBluebell)

    private let trainGreen1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
    private let trainGreen2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
    private let trainGreen3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")
    let trainsGreen = TrainsByDirection(
        trainStation: stationGreen,
        inbound: [trainGreen3],
        outbound: [trainGreen1, trainGreen2])

    private let stationOneWay = TrainStation(
        stationId: "stationId",
        stationIdShort: "LUAS69",
        shortCode: "MAR",
        route: .green,
        name: "Marlborough",
        location: locationBluebell,
        stationType: .oneway)
    let trainsOneWayStation = TrainsByDirection(
        trainStation: stationOneWay,
        inbound: [trainGreen2, trainGreen3],
        outbound: [])

    private let stationFinalStop = TrainStation(
        stationId: "stationId",
        stationIdShort: "stationIdShort",
        shortCode: "TAL",
        route: .red,
        name: "Tallaght",
        location: locationBluebell,
        stationType: .terminal)
    let trainsFinalStop = TrainsByDirection(
        trainStation: stationFinalStop,
        inbound: [trainRed1_outbound, trainRed3_outbound],
        outbound: [])

    let trainsNoTrains = TrainsByDirection(trainStation: stationGreen, inbound: [], outbound: [])

    let trainsNoOutboundTrains = TrainsByDirection(trainStation: stationGreen, inbound: [trainGreen1], outbound: [])

    let lotsOfTrains = TrainsByDirection(
        trainStation: stationGreen,
        inbound: [trainGreen1, trainGreen2, trainGreen3, trainGreen1, trainGreen2, trainGreen3],
        outbound: [trainGreen1, trainGreen2, trainGreen3, trainGreen1, trainGreen2, trainGreen3])

    let trainLongNameOne = TrainsByDirection(
        trainStation: stationGreen,
        inbound: [
            Train(destination: "LUAS The Long Point Station", direction: "Outbound", dueTime: "Due")
        ], outbound: [])

    let trainLongNameThree = TrainsByDirection(
        trainStation: stationGreen,
        inbound: [
            Train(destination: "LUAS The Long Point Station", direction: "Outbound", dueTime: "Due"),
            Train(destination: "LUAS The Long Point Station", direction: "Outbound", dueTime: "12"),
            Train(destination: "LUAS The Long Point Station", direction: "Outbound", dueTime: "100"),
        ], outbound: [])

#endif
