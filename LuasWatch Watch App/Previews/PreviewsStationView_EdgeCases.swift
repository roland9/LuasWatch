//
//  Created by Roland Gropmair on 24/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftUI

#Preview("No trains") {
    makeTabView(AppModel(.foundDueTimes(trainsNoTrains)), .green)
}

#Preview("No out") {
    makeTabView(AppModel(.foundDueTimes(trainsNoOutboundTrains)), .green)
}

#Preview("Lots") {
    makeTabView(AppModel(.foundDueTimes(lotsOfTrains)), .green)
}

#Preview("Long name 1") {
    makeTabView(AppModel(.foundDueTimes(trainLongNameOne)), .green)
}

#Preview("Long name 3") {
    makeTabView(AppModel(.foundDueTimes(trainLongNameThree)), .green)
}
