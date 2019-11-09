//
//  Created by Roland Gropmair on 09/11/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {

	#if DEBUG

	var idx = items.startIndex
	let endIdx = items.endIndex

	repeat {
		Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
		idx += 1
	}
		while idx < endIdx

	#endif
}
