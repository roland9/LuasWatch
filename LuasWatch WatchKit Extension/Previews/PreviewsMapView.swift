//
//  Created by Roland Gropmair on 18/03/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKit

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_MapView: PreviewProvider {
    static var previews: some View {

        Group {

            MapView()
                .previewDisplayName("Map - default Dublin area")
        }
    }
}
#endif
