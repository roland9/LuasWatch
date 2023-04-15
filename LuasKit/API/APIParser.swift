//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

struct APIParser {

	class MessageParser: NSObject, NodeParser {
		var delegateStack: ParserDelegateStack?
		var result: String?

		private var message: String?

		override init() { }

		func parser(_ parser: XMLParser, foundCharacters string: String) {
			message = string
		}

		func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
			// print("📄 \(self.classForCoder) message: \(String( describing: message))")
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
			// print("🔛 \(self.classForCoder) parsing \(elementName) attributeDict \(attributeDict)")

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
			// print("\(self.classForCoder) parsing \(elementName) attributeDict \(attributeDict)")

			switch elementName {
				case "stopInfo":
					// we don't need to parse that info; we hand that in based on the API call we're making for the station
					// print("skip stopInfo")
					break

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

			result =
				TrainsByDirection(trainStation: trainStation,
								  inbound: directionsInboundParser.result ?? [],
								  outbound: directionsOutboundParser.result ?? [],
								  message: messageParser.result)
			delegateStack?.pop()
		}
	}

	public static func parse(xml: Data, for trainStation: TrainStation) -> Result<TrainsByDirection, ParserError> {
		let xmlParser = XMLParser(data: xml)
		let delegateStack = ParserDelegateStack(xmlParser: xmlParser)
		let stopInfoParser = StopInfoParser(trainStation: trainStation)
		delegateStack.push(stopInfoParser)

		if xmlParser.parse() {
			return .success(stopInfoParser.result!)
		} else {
            return .failure(.invalidXML("Invalid XML: \(xmlParser.parserError?.localizedDescription ?? "")"))
		}
	}
}
