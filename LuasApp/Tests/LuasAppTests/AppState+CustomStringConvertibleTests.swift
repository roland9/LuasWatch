//
//  Created by Roland Gropmair on 07/02/2025.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import Testing

@testable import LuasApp

struct AppState_CustomStringConvertibleTests {

  @Test func appState_CustomStringConvertible_returnsString() throws {
    var state: AppState = .idle
    #expect("\(state.description)" == "Idle")

    state = .gettingLocation
    #expect("\(state.description)" == "Getting location...")

    state = .locationAuthorizationUnknown
    #expect("\(state.description)" == "Please grant location access so LuasWatch can find the closest LUAS stop.")

    state = .errorGettingLocation("theMessage")
    #expect("\(state.description)" == "theMessage")

    state = .errorGettingStationTooFarAway("something")
    #expect("\(state.description)" == "Error finding station.\n\n"
            + "Please try again later.")

    state = .errorGettingDueTimes(stationBluebell, "theMessage")
    #expect("\(state.description)" == "theMessage")

    state = .loadingDueTimes(stationBluebell, cachedTrains: nil)
    #expect("\(state.description)" == "Getting times for Bluebell...")

    state = .foundDueTimes(trainsRed_1_1)
    #expect("\(state.description)" == "Found times: TrainsByDirection(station: <short id 2> \"station name 2\"  (53.3292817872831/-6.33382500275916)  type: .terminal, inbound: [Saggart: 5 mins], outbound: [The Point: 2 mins], message: nil)")
  }
}
