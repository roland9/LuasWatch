import Foundation

public protocol API2 {
	static func getTrains(shortCode: String, completion: @escaping (Data?, Error?) -> Void)
}

public extension API2 {

	static func dueTime(for trainStation: TrainStation, completion: @escaping (Result<TrainsByDirection>) -> Void) {

		Self.getTrains(shortCode: trainStation.shortCode) { (data, error) in

			if let data = data {

				let result = API2Parser.parse(xml: data, for: trainStation)

				switch result {
					case .error(let message):
						completion(.error(message))
					case .success(let trainsByDirection):
						//	previously in API v1 we had this condition; not sure it might also happen in v2
						if trainsByDirection.inbound.isEmpty && trainsByDirection.outbound.isEmpty {
							completion(.error("No trains found"))
						} else {
							completion(.success(trainsByDirection))
						}
				}

			} else if let error = error {
				completion(.error("Error getting results from server: \(error.localizedDescription)"))
			} else {
				completion(.error("Error getting results from server"))
			}
		}
	}
}

public struct LuasAPI2: API2 {

	public static func getTrains(shortCode: String, completion: @escaping (Data?, Error?) -> Void) {

		let url = URL(string: "https://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop=\(shortCode)&encrypt=false")!

		let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
			completion(data, error)
		}
		dataTask.resume()
	}

	public init() {
		//
	}
}

public struct LuasMockAPI2: API2 {

	public static func getTrains(shortCode: String, completion: @escaping (Data?, Error?) -> Void) {
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
				<tram dueMins="9" destination="Bride's Glen" />
			</direction>
			<direction name="Outbound">
				<tram dueMins="15" destination="Bride's Glen" />
			</direction>
		</stopInfo>
"""
		completion((xml as NSString).data(using: String.Encoding.utf8.rawValue)!, nil)
	}

	public init() { }
}

public struct LuasMockEmptyAPI2: API2 {

	public static func getTrains(shortCode: String, completion: @escaping (Data?, Error?) -> Void) {
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

		completion((xml as NSString).data(using: String.Encoding.utf8.rawValue)!, nil)
	}

	public init() { }
}
