//
//  Created by Roland Gropmair on 26/12/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation
import Testing

@testable import LuasAPI

@Suite struct LuasAPITests {

  @Test func luasAPI_buildsAPIRequest() async throws {
    let session = LuasMockSession()
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

  @Test func loadData_fromMockAPI() async throws {
    let session = LuasMockSession()
    let api = LuasAPI(session: session)

    let data = try await api.getTrains(stationShortCode: "RAN")
    #expect(data.isEmpty == false)
  }
}
