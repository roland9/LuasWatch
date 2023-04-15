import Foundation

public enum Result<T> {
    case error(String)
    case success(T)
}

typealias JSONDictionary = [String: Any]

public protocol API {
    static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection>
}

protocol APIInternal: API {
    static func getTrains(shortCode: String) async throws -> Data
}

extension APIInternal {

    public static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection> {

        do {
            let data = try await getTrains(shortCode: trainStation.shortCode)

            let result = API2Parser.parse(xml: data, for: trainStation)

            switch result {
                case .error(let message):
                    return .error(message)

                case .success(let trainsByDirection):

                    // success - but no trains!
                    if trainsByDirection.inbound.isEmpty && trainsByDirection.outbound.isEmpty {

                        // if we get message, we return that as an error
                        // otherwise we return an error: no trains
                        return .error(trainsByDirection.message ??
                                      LuasStrings.noTrainsErrorMessage + "\n\n" +
                                      LuasStrings.noTrainsFallbackExplanation)

                    } else {
                        return .success(trainsByDirection)
                    }
            }

        } catch {

            return .error("Error getting results from server: \(error.localizedDescription)")
        }
    }
}

public struct LuasAPI: API, APIInternal {

    static func getTrains(shortCode: String) async throws -> Data {

		let url = URL(string: "https://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=\(shortCode)&encrypt=false")!

        let (data, _) = try await URLSession.shared.data(from: url)

        return data
	}
}
