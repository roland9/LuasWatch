//
//  Created by Roland Gropmair on 15/04/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import Foundation

struct MockAPIWorker: APIWorker {

    enum Scenario {
        case ranelaghTrains, noTrainsButMessage, noTrainsNoMessage // etc.
        case serverError
        case parserError
    }

    // in the unit test, we can define the scenario we want to test
    var scenario: Scenario = .ranelaghTrains

    // swiftlint:disable:next function_body_length
    func getTrains(shortCode: String) async throws -> Data {

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
                throw NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)

            case .parserError:
                xml = "some invalid xml"
                throw APIError.invalidXML(xml)
        }

        return (xml as NSString).data(using: String.Encoding.utf8.rawValue)!
    }
}
