import Foundation

struct Train: CustomDebugStringConvertible {
	let destination: String
	let direction: String
	let dueTime: String

	var debugDescription: String {
		return "\(destination) - due: \'\(dueTime)\'"
	}
}

struct TrainsByDirection {
	let inbound: [Train]
	let outbound: [Train]
}

enum Result<T> {
	case error(String)
	case success(T)
}

typealias JSONDictionary = [String: Any]

protocol API {
	func getTrains(stopName: String, completion: @escaping (Data?, Error?) -> Void)
}

func dueTime(for stopName: String, api: API, completion: @escaping (Result<TrainsByDirection>) -> Void) {

	api.getTrains(stopName: stopName) { (data, error) in
		if let data = data,
			let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
			//			print("\(json)")

			if let errorMessage = json["errormessage"] as? String,
				errorMessage.count > 0 {
				completion(.error(errorMessage))
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
					completion(.success(trainsByDirection))
				} else {
					completion(.error("Could not group inbound / outbound trains"))
				}

			} else {
				completion(.error("Error parsing results"))
			}

		}
	}
}

let stopName = "LUAS70"

struct LuasAPI: API {

	func getTrains(stopName: String, completion: @escaping (Data?, Error?) -> Void) {
		let url = URL(string: "https://data.smartdublin.ie/cgi-bin/rtpi/realtimebusinformation?stopid=\(stopName)&format=json")!
		let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
			completion(data, error)
		}
		dataTask.resume()
	}
}

dueTime(for: stopName, api: LuasAPI()) { (result) in
	switch result {
	case .error(let message):
		print(message)
	case .success(let trains):
		print(trains)
	}
}

struct LuasMockAPI: API {

	func getTrains(stopName: String, completion: @escaping (Data?, Error?) -> Void) {
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

		// swiftlint:disable:next force_try
		completion(try! JSONSerialization.data(withJSONObject: json, options: []), nil)
	}
}

dueTime(for: stopName, api: LuasMockAPI()) { (result) in
	switch result {
	case .error(let message):
		print(message)
	case .success(let trains):
		print(trains)
	}
}
