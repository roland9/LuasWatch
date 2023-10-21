import Foundation
import CoreLocation

/* example input
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
 <tram dueMins="9" destination="Bride's Glen" />
     </direction>
 <direction name="Outbound">
 <tram dueMins="15" destination="Bride's Glen" />
     </direction>
 </stopInfo>
*/
import LuasKitIOS

/* another example input
 <stopInfo created="2020-09-10T20:35:43" stop="St. Stephen's Green" stopAbv="STS">
 <message>Green Line services operating with delays</message>
 <direction name="Inbound">
 <tram dueMins="DUE" destination="Broombridge" />
 <tram dueMins="6" destination="Parnell" />
 <tram dueMins="11" destination="Broombridge" />
 <tram dueMins="18" destination="Parnell" />
 </direction>
 <direction name="Outbound">
 <tram dueMins="1" destination="Bride's Glen" />
 <tram dueMins="3" destination="Sandyford" />
 <tram dueMins="10" destination="Bride's Glen" />
 <tram dueMins="17" destination="Sandyford" />
 </direction>
 </stopInfo>
*/

let xml = """
<stopInfo created="2020-09-10T20:39:57" stop="Tallaght" stopAbv="TAL">
<message>Red Line services operating normally</message>
<direction name="Inbound">
<tram dueMins="10" destination="The Point" />
</direction>
<direction name="Outbound">
<tram destination="No trams forecast" dueMins="" />
</direction>
</stopInfo>
"""

// http://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=ran&encrypt=false

let data = (xml as NSString).data(using: String.Encoding.utf8.rawValue)!

// credit to https://github.com/nsscreencast/425-parsing-xml-in-swift/blob/master/SwiftParsingXML/SwiftParsingXML/main.swift

protocol ParserDelegate: XMLParserDelegate {
    var delegateStack: ParserDelegateStack? { get set }
    func didBecomeActive()
}

extension ParserDelegate {
    func didBecomeActive() { }
}

protocol NodeParser: ParserDelegate {
    associatedtype Item
    var result: Item? { get }
}

class ParserDelegateStack {
    private var parsers: [ParserDelegate] = []
    private let xmlParser: XMLParser

    init(xmlParser: XMLParser) {
        self.xmlParser = xmlParser
    }

    func push(_ parser: ParserDelegate) {
        parser.delegateStack = self
        xmlParser.delegate = parser
        parsers.append(parser)
    }

    func pop() {
        parsers.removeLast()
        if let next = parsers.last {
            xmlParser.delegate = next
            next.didBecomeActive()
        } else {
            xmlParser.delegate = nil
        }
    }
}

class MessageParser: NSObject, NodeParser {
    var delegateStack: ParserDelegateStack?
    var result: String?

    private var message: String?

    override init() { }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        message = string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("📄 \(self.classForCoder) message: \(String( describing: message))")
        result = message
        delegateStack?.pop()
    }
}

class DirectionParser: NSObject, NodeParser {
    var result: [Train]? = []
    var delegateStack: ParserDelegateStack?

    var direction: String

    init(direction: String) {
        self.direction = direction
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        print("🔛 \(self.classForCoder) parsing \(elementName) attributeDict \(attributeDict)")

        if elementName == "tram" {
            if // let destination = attributeDict["destination"],
               let dueMins = attributeDict["dueMins"] {
                if description != "No trams forecast" && dueMins != "" {
                    let train = Train(destination: attributeDict["destination"]!, direction: direction, dueTime: attributeDict["dueMins"]!)
                    result?.append(train)
                }
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "direction" {
            delegateStack?.pop()
        }
    }

}

class StopInfoParser: NSObject, NodeParser {
    var delegateStack: ParserDelegateStack?
    var result: TrainsByDirection?

    private let trainStation: TrainStation

    private let messageParser = MessageParser()
    private let directionsInboundParser = DirectionParser(direction: "Inbound")
    private let directionsOutboundParser = DirectionParser(direction: "Outbound")

    init(trainStation: TrainStation) {
        self.trainStation = trainStation
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        print("\(self.classForCoder) parsing \(elementName) attributeDict \(attributeDict)")

        switch elementName {
            case "stopInfo":
                // we don't need to parse that info; we hand that in based on the API call we're making for the station
                print("skip stopInfo")

            case "message":
                delegateStack?.push(messageParser)

            case "direction":

                if attributeDict["name"] == "Inbound" {
                    delegateStack?.push(directionsInboundParser)

                } else if attributeDict["name"] == "Outbound" {
                    delegateStack?.push(directionsOutboundParser)
            }

            default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        let message: String? = messageParser.result

        result =
            TrainsByDirection(trainStation: trainStation,
                              inbound: directionsInboundParser.result ?? [],
                              outbound: directionsOutboundParser.result ?? [],
                              message: message)
        delegateStack?.pop()
    }
}

let xmlData = xml.data(using: .utf8)!
let xmlParser = XMLParser(data: xmlData)
let delegateStack = ParserDelegateStack(xmlParser: xmlParser)

// we know this information based on the user location, no need to parse the xml for that
let trainStation = TrainStation(stationId: "theStationId", stationIdShort: "stationIdShort", shortCode: "RAN",
                                route: .green, name: "Ranelagh", location: CLLocation(), stationType: .twoway)

let stopInfoParser = StopInfoParser(trainStation: trainStation)
delegateStack.push(stopInfoParser)

if xmlParser.parse() {
    print("Done parsing")
    print(stopInfoParser.result!)
} else {
    print("Invalid xml", xmlParser.parserError?.localizedDescription ?? "")
}

