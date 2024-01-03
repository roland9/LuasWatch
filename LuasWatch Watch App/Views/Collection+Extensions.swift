//
//  Created by Roland Gropmair on 03/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
