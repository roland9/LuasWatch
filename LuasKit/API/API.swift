import Foundation

public enum ParserError: Error {
    case invalidXML(String)
}

public enum APIError: Error {
    case noTrains(String), serverFailure(String), parserError(ParserError)
}

public protocol API {
    static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection, APIError>
}

protocol APIInternal: API {
    static func getTrains(shortCode: String) async throws -> Data
}

extension APIInternal {

    public static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection, APIError> {

        do {
            let data = try await getTrains(shortCode: trainStation.shortCode)

            let result = APIParser.parse(xml: data, for: trainStation)

            switch result {
                case .failure(let message):
                    return .failure(.parserError(message))

                case .success(let trainsByDirection):

                    // success - but no trains!
                    if trainsByDirection.inbound.isEmpty && trainsByDirection.outbound.isEmpty {

                        // if we get message, we return that as an error
                        // otherwise we return an error: no trains
                        return .failure(.noTrains(trainsByDirection.message ??
                                      LuasStrings.noTrainsErrorMessage + "\n\n" +
                                      LuasStrings.noTrainsFallbackExplanation))

                    } else {
                        return .success(trainsByDirection)
                    }
            }

        } catch {

            return .failure(.serverFailure(LuasStrings.noTrainsErrorMessage + "\n\n" +
                                           LuasStrings.noTrainsFallbackExplanation))
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
