import Foundation

public protocol API2 {
    static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection>
}

protocol API2Internal: API2 {
    static func getTrains(shortCode: String) async throws -> Data
}

extension API2Internal {

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

public struct LuasAPI2: API2, API2Internal {

    static func getTrains(shortCode: String) async throws -> Data {

		let url = URL(string: "https://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=\(shortCode)&encrypt=false")!

        let (data, _) = try await URLSession.shared.data(from: url)

        return data
	}
}

struct LuasMockAPI2: API2, API2Internal {

    enum Scenario {
        case ranelaghTrains, noTrainsButMessage, noTrainsNoMessage // etc.
        case serverError
    }

    // in the unit test, we can define the scenario we want to test
    static var scenario: Scenario = .ranelaghTrains

    static func getTrains(shortCode: String) async throws -> Data {

        var xml: String

        switch scenario {
            case .ranelaghTrains:
                xml = """
                <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
                    <message>Green Line services operating normally</message>
                    <direction name="Inbound">
                        <tram dueMins="Due" destination="Broombridge" />
                    </direction>
                    <direction name="Inbound">
                        <tram dueMins="5" destination="Broombridge" />
                    </direction>
                    <direction name="Outbound">
                        <tram dueMins="7" destination="Bride's Glen" />
                    </direction>
                    <direction name="Outbound">
                        <tram dueMins="9" destination="Sandyford" />
                    </direction>
                    <direction name="Outbound">
                        <tram dueMins="15" destination="Bride's Glen" />
                    </direction>
                </stopInfo>
                """

            case .noTrainsButMessage:
                xml = """
                <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
                    <message>Green Line services operating normally</message>
                    <direction name="Inbound">
                        <tram destination="No trams forecast" dueMins="" />
                    </direction>
                    <direction name="Outbound">
                        <tram destination="No trams forecast" dueMins="" />
                    </direction>
                </stopInfo>
                """

            case .noTrainsNoMessage:
                xml = """
                <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
                    <direction name="Inbound">
                        <tram destination="No trams forecast" dueMins="" />
                    </direction>
                    <direction name="Outbound">
                        <tram destination="No trams forecast" dueMins="" />
                    </direction>
                </stopInfo>
                """

            case .serverError:
                throw LuasError.someServerError
        }

        return (xml as NSString).data(using: String.Encoding.utf8.rawValue)!
    }

    enum LuasError: Error {
        case someServerError
    }
}
