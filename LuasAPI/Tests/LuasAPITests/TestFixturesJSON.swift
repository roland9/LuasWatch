//
//  Created by Roland Gropmair on 11/01/2025.
//

import Foundation

enum APIResponseJSON {

  static let trainsRanelagh: Data =
    """
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
    """.data(using: .utf8)!

  static let noTrainsWithMessage: Data =
    """
      <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
          <message>Green Line services operating normally</message>
          <direction name="Inbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
          <direction name="Outbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
      </stopInfo>
    """.data(using: .utf8)!

  static let noTrainsButMessageWithApostrophe: Data =
    """
      <stopInfo created=\"2023-04-15T23:27:12\" stop=\"Beechwood\" stopAbv=\"BEE\">
          <message>No service Stephen’s Green – Beechwood. See news</message>
          <direction name=\"Inbound\">
              <tram destination=\"See news for information\" dueMins=\"\" />
          </direction>
          <direction name=\"Outbound\">
              <tram destination=\"See news for information\" dueMins=\"\" />
          </direction>
      </stopInfo>
    """.data(using: .utf8)!

  static let noTrainsNoMessage: Data =
    """
      <stopInfo created="2020-08-16T22:07:29" stop="Ranelagh" stopAbv="RAN">
          <direction name="Inbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
          <direction name="Outbound">
              <tram destination="No trams forecast" dueMins="" />
          </direction>
      </stopInfo>
    """.data(using: .utf8)!
}
