//
//  Created by Roland Gropmair on 04/09/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public struct LuasStrings {

	public static let luasWatchErrorDomain = "ie.mapps.LuasWatch"

	public static let emptyDueTimesErrorMessage = "Unfortunately we couldn’t get any due times for the %@ Luas station at this moment. Either the Luas is not operating right now, or there is a system problem with the Real Time Passenger Information (RTPI) Service.\n\nPlease try again later."
}

public struct LuasErrors {

	public static let errorLocationTooFarAway =
		NSError(domain: LuasStrings.luasWatchErrorDomain,
				code: 100,
				userInfo: ["message": NSLocalizedString("It looks like the closest Luas station is quite far away.\n\nPlease use the Luas Watch app again when you’re closer to the Dublin Area.", comment: "")])		

}
