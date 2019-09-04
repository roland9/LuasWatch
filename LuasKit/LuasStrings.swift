//
//  Created by Roland Gropmair on 04/09/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public struct LuasStrings {

	public static let luasWatchErrorDomain = "ie.mapps.LuasWatch"

}

public struct LuasErrors {

	public static let errorLocationTooFarAway =
		NSError(domain: LuasStrings.luasWatchErrorDomain,
				code: 100,
				userInfo: ["message": NSLocalizedString("It looks like the closest Luas station is quite far away.\n\nPlease use the Luas Watch app again when you’re closer to the Dublin Area.", comment: "")])		

}
