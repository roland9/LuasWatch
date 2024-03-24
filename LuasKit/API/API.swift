//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public protocol APIWorker {
    func getTrains(shortCode: String) async throws -> Data
}

public protocol API {
    var apiWorker: APIWorker { get set }

    func dueTimes(for trainStation: TrainStation) async throws -> TrainsByDirection

    init(apiWorker: APIWorker)
}

public enum APIError: Error {
    case noTrains(String)
    case invalidXML(String)
}

public struct LuasAPI: API {

    public var apiWorker: APIWorker

    public init(apiWorker: APIWorker) {
        self.apiWorker = apiWorker
    }

    public func dueTimes(for trainStation: TrainStation) async throws -> TrainsByDirection {

        let data = try await apiWorker.getTrains(shortCode: trainStation.shortCode)

        let trainsByDirection = try APIParser.parse(xml: data, for: trainStation)

        // success - but no trains!
        if trainsByDirection.inbound.isEmpty && trainsByDirection.outbound.isEmpty {

            // if we get message, we return that as an error
            // otherwise we return an error: no trains
            throw APIError.noTrains(trainsByDirection.message ?? "\(LuasStrings.noTrainsErrorMessage)\n\n\(LuasStrings.noTrainsFallbackExplanation)")
        } else {
            return trainsByDirection
        }
    }
}

public struct RealAPIWorker: APIWorker {

    public func getTrains(shortCode: String) async throws -> Data {

        let url = URL(string: "https://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=\(shortCode)&encrypt=false")!

        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)

        let session = URLSession.shared

        let (data, _) = try await session.data(for: urlRequest)

        return data
    }

    public init() {}
}
