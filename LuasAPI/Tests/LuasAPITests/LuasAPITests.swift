//
//  Created by Roland Gropmair on 26/12/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import Testing

@testable import LuasAPI

@Suite struct LuasAPITests {

  @Test func luasAPI_buildsAPIRequest() async throws {
    let session = LuasMockSession(mockData: "someData".data(using: .utf8)!)
    let api = LuasAPI(session: session)
    let request = api.buildRequest(stationShortCode: "RAN")

    #expect(request.httpMethod == "GET")
    #expect(request.httpBody == nil)
    #expect(request.value(forHTTPHeaderField: "Accept") == nil)
    #expect(request.cachePolicy == .reloadIgnoringLocalCacheData)
    #expect(request.timeoutInterval == 5)
    #expect(request.url?.absoluteString
            == "https://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=RAN&encrypt=false"
    )
  }

  //@Test func luasAPI_loadsData_fromRealAPI() async throws {
  //  let session = URLSession(configuration: .default)
  //  let api = LuasAPI(session: session)
  //
  //  let data = try await api.getTrains(stationShortCode: "RAN")
  //  #expect(data.isEmpty == false)
  //}

  @Test func loadData_fromMockAPI_returnsData() async throws {
    let session = LuasMockSession(
      mockData: APIResponseJSON.trainsRanelagh
    )
    let api = LuasAPI(session: session)

    let data = try await api.getTrains(stationShortCode: "RAN")
    #expect(data.isEmpty == false)
  }

  @Test func dueTimes_returnsTrains() async throws {
    let session = LuasMockSession(
      mockData: APIResponseJSON.trainsRanelagh
    )
    let api = LuasAPI(session: session)

    let dueTimes = try await api.dueTimes(for: stationGreen)

    #expect(dueTimes.station.name == "station name 1")
    #expect(
      dueTimes.inbound == [
        Train(
          destination: "Broombridge",
          direction: "Inbound",
          dueTime: "Due"
        ),
        Train(
          destination: "Broombridge",
          direction: "Inbound",
          dueTime: "5"
        )
      ]
    )
    #expect(
      dueTimes.outbound == [
        Train(
          destination: "Bride's Glen",
          direction: "Outbound",
          dueTime: "7"
        ),
        Train(
          destination: "Sandyford",
          direction: "Outbound",
          dueTime: "9"
        ),
        Train(
          destination: "Bride's Glen",
          direction: "Outbound",
          dueTime: "15"
        )
      ]
    )
  }

  @Test func dueTimes_inboundOutboundEmptyNoMessage_throwsAPIErrorNoTrains() async throws {
    let session = LuasMockSession(
      mockData: APIResponseJSON.noTrainsNoMessage
    )
    let api = LuasAPI(session: session)

    await #expect(performing: {
      try await api.dueTimes(for: stationGreen)
    }, throws: { error in
      (error as? APIError) == .noTrains
    })
  }

  @Test func dueTimes_inboundOutboundEmptyWithMessage_throwsAPIErrorNoTrainsWithMessage() async throws {
    let session = LuasMockSession(
      mockData: APIResponseJSON.noTrainsWithMessage
    )
    let api = LuasAPI(session: session)

    await #expect(performing: {
      try await api.dueTimes(for: stationGreen)
    }, throws: { error in
      (error as? APIError) == .noTrainsButMessageFromAPI("Green Line services operating normally")
    })
  }}
