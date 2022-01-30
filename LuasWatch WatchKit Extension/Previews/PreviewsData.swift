//
//  Created by Roland Gropmair on 25/09/2021.
//  Copyright © 2021 mApps.ie. All rights reserved.
//

import SwiftUI
import CoreLocation

#if os(iOS)
import LuasKitIOS
#endif

#if os(watchOS)
import LuasKit
#endif

#if DEBUG
////  Previews
let location = CLLocation(latitude: CLLocationDegrees(Double(1.1)),
						  longitude: CLLocationDegrees(Double(1.2)))

let stationRed = TrainStation(stationId: "stationId",
							  stationIdShort: "LUAS8",
							  shortCode: "BLU",
							  route: .red,
							  name: "Bluebell",
							  location: location)
let trainRed1 = Train(destination: "LUAS The Point", direction: "Outbound", dueTime: "Due")
let trainRed2 = Train(destination: "LUAS Tallaght", direction: "Outbound", dueTime: "9")
let trainRed3 = Train(destination: "LUAS Connolly", direction: "Inbound", dueTime: "12")

let trainsRed_1_1 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed3],
									  outbound: [trainRed2])
let trainsRed_2_1 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed3],
									  outbound: [trainRed2])
let trainsRed_3_2 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed2, trainRed3],
									  outbound: [trainRed1, trainRed2])
let trainsRed_4_4 = TrainsByDirection(trainStation: stationRed,
									  inbound: [trainRed1, trainRed2, trainRed3, trainRed3],
									  outbound: [trainRed1, trainRed2, trainRed3, trainRed3])

let stationGreen = TrainStation(stationId: "stationId",
								stationIdShort: "LUAS69",
								shortCode: "PHI",
								route: .green,
								name: "Phibsboro",
								location: location)

let trainGreen1 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "Due")
let trainGreen2 = Train(destination: "LUAS Broombridge", direction: "Outbound", dueTime: "9")
let trainGreen3 = Train(destination: "LUAS Sandyford", direction: "Inbound", dueTime: "12")

let trainsGreen = TrainsByDirection(trainStation: stationGreen,
									inbound: [trainGreen3],
									outbound: [trainGreen1, trainGreen2])

let stationOneWay = TrainStation(stationId: "stationId",
								 stationIdShort: "LUAS69",
								 shortCode: "MAR",
								 route: .green,
								 name: "Marlborough",
								 location: location,
								 stationType: .oneway)
let trainsOneWayStation = TrainsByDirection(trainStation: stationOneWay,
											inbound: [trainGreen2, trainGreen3],
											outbound: [])

let stationFinalStop = TrainStation(stationId: "stationId",
									stationIdShort: "stationIdShort",
									shortCode: "TAL",
									route: .red,
									name: "Tallaght",
									location: location,
									stationType: .terminal)
let trainsFinalStop = TrainsByDirection(trainStation: stationFinalStop,
										inbound: [trainRed1, trainRed3],
										outbound: [])
let directionBoth: Direction = .both

#endif

