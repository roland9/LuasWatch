//
//  Created by Roland Gropmair on 26/12/2024.
//

public enum APIError: Error {
  case noTrains(String)
  case invalidXML(String)
}
