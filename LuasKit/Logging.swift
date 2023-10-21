//
//  Created by Roland Gropmair on 09/11/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

// inspired by https://gist.github.com/ccheptea/324e40dc905c961d87a62f65f7ba0462

public func myPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", function: String = #function, file: String = #file, line: Int = #line) {

#if DEBUG

    let formatter: DateFormatter = {
        let _formatter = DateFormatter()
        _formatter.dateFormat = "H:m:ss.SSS"
        return _formatter
    }()

    var idx = items.startIndex
    let endIdx = items.endIndex

    let dateString = formatter.string(from: NSDate.now)

    let lastSlashIndex = (file.lastIndex(of: "/") ?? String.Index(utf16Offset: 0, in: file))
    let nextIndex = file.index(after: lastSlashIndex)
    let filename = file.suffix(from: nextIndex).replacingOccurrences(of: ".swift", with: "")

    let prefix = "\(dateString) \(filename).\(function):\(line)"

    repeat {
        Swift.print("\(prefix) \(items[idx])", separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
        idx += 1
    } while idx < endIdx

#endif
}
