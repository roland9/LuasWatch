//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public enum Result<T> {
	case error(String)
	case success(T)
}

typealias JSONDictionary = [String: Any]

public protocol API {
	static func getTrains(stopName: String, completion: @escaping (Data?, Error?) -> Void)
}

public extension API {

	static func dueTime(for stopName: String, completion: @escaping (Result<TrainsByDirection>) -> Void) {

		Self.getTrains(stopName: stopName) { (data, error) in
			if let data = data,
				let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
				//			print("\(json)")

				if let errorMessage = json["errormessage"] as? String,
					errorMessage.count > 0 {
					DispatchQueue.main.async {
						completion(.error(errorMessage))
					}
					return
				}

				if let results = (json["results"] as? [JSONDictionary]) {

					let trains: [Train] = results.compactMap { (train) in
						if let destination = train["destination"] as? String,
							let direction = train["direction"] as? String,
							let dueTime = train["duetime"] as? String {
							return Train(destination: destination, direction: direction, dueTime: dueTime)
						} else {
							return nil
						}
					}
					let groupedTrains = Dictionary(grouping: trains, by: { $0.direction })

					if let inboundTrains = groupedTrains["Inbound"], let outboundTrains = groupedTrains["Outbound"] {
						let trainsByDirection = TrainsByDirection(inbound: inboundTrains, outbound: outboundTrains)
						DispatchQueue.main.async {
							completion(.success(trainsByDirection))
						}
					} else {
						DispatchQueue.main.async {
							completion(.error("Could not group inbound / outbound trains"))
						}
					}

				} else {
					DispatchQueue.main.async {
						completion(.error("Error parsing results"))
					}
				}

			}
		}
	}
}

public struct LuasAPI: API {

	public static func getTrains(stopName: String, completion: @escaping (Data?, Error?) -> Void) {
		let url = URL(string: "https://data.smartdublin.ie/cgi-bin/rtpi/realtimebusinformation?stopid=\(stopName)&format=json")!
		let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
			completion(data, error)
		}
		dataTask.resume()
	}

	public init() {
		//
	}
}

public struct LuasMockAPI: API {

	public static func getTrains(stopName: String, completion: @escaping (Data?, Error?) -> Void) {
		let json: JSONDictionary =
			[
				"errormessage": "",
				"results": [
					[
						"destination": "LUAS Bride's Glen",
						"direction": "Outbound",
						"duetime": "Due"
					],
					[
						"destination": "LUAS Broombridge",
						"direction": "Inbound",
						"duetime": "6"
					],
					[
						"destination": "LUAS Bride's Glen",
						"direction": "Outbound",
						"duetime": "15"
					]
				]
		]

		// swiftlint:disable force_try
		completion(try! JSONSerialization.data(withJSONObject: json, options: []), nil)
	}

	public init() {
		//
	}
}
