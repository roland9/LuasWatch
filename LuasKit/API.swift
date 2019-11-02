import Foundation

public enum Result<T> {
	case error(String)
	case success(T)
}

typealias JSONDictionary = [String: Any]

public protocol API {
	static func getTrains(stationId: String, completion: @escaping (Data?, Error?) -> Void)
}

public extension API {

	static func dueTime(for trainStation: TrainStation, completion: @escaping (Result<TrainsByDirection>) -> Void) {

		Self.getTrains(stationId: trainStation.stationIdShort) { (data, error) in
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

					var inboundTrains = [Train]()
					var outboundTrains = [Train]()

					if let inbound = groupedTrains["Inbound"] {
						inboundTrains = inbound
					}

					if let outbound = groupedTrains["Outbound"] {
						outboundTrains = outbound
					}

					if inboundTrains.isEmpty && outboundTrains.isEmpty {
						DispatchQueue.main.async {
							completion(.error(String(format: LuasStrings.emptyDueTimesErrorMessage, trainStation.name)))
						}
						return
					}

					let trainsByDirection = TrainsByDirection(trainStation: trainStation,
															  inbound: inboundTrains,
															  outbound: outboundTrains)
					DispatchQueue.main.async {
						completion(.success(trainsByDirection))
					}

				} else {
					DispatchQueue.main.async {
						completion(.error("Error parsing results"))
					}
				}

			} else {

				DispatchQueue.main.async {
					if let error = error {
						if (error as NSError).code == NSURLErrorNotConnectedToInternet {
							completion(.error(LuasStrings.errorNoInternet))
						} else {
							completion(.error(NSLocalizedString("Error getting due times from internet: \(error.localizedDescription)", comment: "")))
						}
					} else {
						completion(.error(NSLocalizedString("Error getting due times from internet.\n\nPlease try agin later.", comment: "")))
					}
				}
			}
		}
	}
}

public struct LuasAPI: API {

	public static func getTrains(stationId: String, completion: @escaping (Data?, Error?) -> Void) {
		let url = URL(string: "https://data.smartdublin.ie/cgi-bin/rtpi/realtimebusinformation?stopid=\(stationId)&format=json")!
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

	public static func getTrains(stationId: String, completion: @escaping (Data?, Error?) -> Void) {
		let json: JSONDictionary =
			[
				"errormessage": "",
				"results": [
					[
						"destination": "LUAS Bride's Glen",
						"direction": "Outbound",
						"duetime": "Due",
						"route": "Green"
					],
					[
						"destination": "LUAS Broombridge",
						"direction": "Inbound",
						"duetime": "6",
						"route": "Green"
					],
					[
						"destination": "LUAS Tallaght",
						"direction": "Outbound",
						"duetime": "15",
						"route": "Red"
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

public struct LuasMockEmptyAPI: API {

	public static func getTrains(stationId: String, completion: @escaping (Data?, Error?) -> Void) {
		let json: JSONDictionary =
			[
				"errormessage": "",
				"results": []
		]

		// swiftlint:disable force_try
		completion(try! JSONSerialization.data(withJSONObject: json, options: []), nil)
	}

	public init() {
		//
	}
}

public struct LuasMockErrorAPI: API {

	public static func getTrains(stationId: String, completion: @escaping (Data?, Error?) -> Void) {

		completion(nil, NSError(domain: "luaswatch", code: 100, userInfo: nil))
	}

	public init() {
		//
	}
}
