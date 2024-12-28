//
//  Created by Roland Gropmair on 26/12/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

public struct LuasAPI {

  private let session: URLSessionLoading

  init(session: URLSessionLoading) {
    self.session = session
  }

  internal func buildRequest(stationShortCode: String) -> URLRequest {

    var urlComponents: URLComponents {
      var urlComponents = URLComponents()
      urlComponents.scheme = "https"
      urlComponents.host = "luasforecasts.rpa.ie"
      urlComponents.path = "/xml/get.ashx"
      urlComponents.queryItems = [
        URLQueryItem(name: "action", value: "forecast"),
        URLQueryItem(name: "stop", value: stationShortCode),
        URLQueryItem(name: "encrypt", value: "false"),
      ]
      return urlComponents
    }

    guard let url = urlComponents.url else {
      fatalError("error building URL request")
    }

    return URLRequest(
      url: url,
      cachePolicy: .reloadIgnoringLocalCacheData,
      timeoutInterval: 5
    )
  }

  public func getTrains(stationShortCode: String) async throws -> Data {

    let request = buildRequest(stationShortCode: stationShortCode)

    let (data, _) = try await session.data(for: request)

    return data
  }
}

public protocol URLSessionLoading {

  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionLoading {
  // only to define protocol conformance
}
