import Foundation

public protocol API2 {
    static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection>
}

protocol API2Internal {
    static func getTrains(shortCode: String) async throws -> Data
    static func dueTimes(for trainStation: TrainStation) async -> Result<TrainsByDirection>
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
                    if trainsByDirection.inbound.isEmpty && trainsByDirection.outbound.isEmpty {
                        if let message = trainsByDirection.message {
                            return .error(message)
                        } else {
                            let errorString = LuasStrings.noTrainsErrorMessage + "\n\n" +
                            LuasStrings.noTrainsFallbackExplanation
                            return .error(errorString)
                        }

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

    public init() {
        //
    }
}

public struct LuasMockAPI2: API2, API2Internal {

    static func getTrains(shortCode: String) async throws -> Data {

        let xml = """
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

        return (xml as NSString).data(using: String.Encoding.utf8.rawValue)!
    }

    public init() { }
}

public struct LuasMockEmptyAPI2: API2, API2Internal {

    static func getTrains(shortCode: String) async throws -> Data {

        let xml = """
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

        return (xml as NSString).data(using: String.Encoding.utf8.rawValue)!
    }

    public init() { }
}
