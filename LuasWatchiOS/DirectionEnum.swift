//
//  Created by Roland Gropmair on 09/06/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import AppIntents
import LuasKit

/// Cannot use the Direction from LuasKit??
// Unable to determine value type for type `LuasKit.Direction`

enum DirectionEnum: String, CaseIterable, AppEnum {

    case both, inbound, outbound

    static var typeDisplayName: LocalizedStringResource = "Direction"

    public static var typeDisplayRepresentation = 
    TypeDisplayRepresentation(name: "Direction of the train (for stations that have both)")

    public static var caseDisplayRepresentations: [DirectionEnum: DisplayRepresentation] {
        [.inbound: "inbound trains", .outbound: "outbound trains", .both: "both directions"]
    }
}

extension DirectionEnum {

    var toLuasKitDirection: Direction {
        switch self {

        case .both:
            return .both
        case .inbound:
            return .inbound
        case .outbound:
            return .outbound
        }
    }
}
