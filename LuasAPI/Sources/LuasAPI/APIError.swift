//
//  Created by Roland Gropmair on 26/12/2024.
//

public enum APIError: Error, Equatable {

  /// returns a string if there was a `message` field in the API response XML
  case noTrainsButMessageFromAPI(String)

  case noTrains

  case invalidXML(String)
}
