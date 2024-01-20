//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Combine
import CoreLocation
import SwiftUI

// WIP remove
public enum MyState {

    case locationAuthorizationUnknown

    case gettingLocation
    case errorGettingLocation(String)

    case errorGettingStation(String)  // in case the user is too far away

    case gettingDueTimes(TrainStation, CLLocation)
    case errorGettingDueTimes(TrainStation, String)

    case foundDueTimes(TrainsByDirection, CLLocation)

    case updatingDueTimes(TrainsByDirection, CLLocation)
}

extension MyState: CustomStringConvertible {

    public var description: String {
        switch self {

            case .locationAuthorizationUnknown:
                return LuasStrings.locationAuthorizationUnknown

            case .gettingLocation:
                return LuasStrings.gettingLocation

            case .errorGettingLocation(let errorMessage):
                return errorMessage

            case .errorGettingStation:
                return LuasStrings.errorGettingStation

            case .gettingDueTimes(let trainStation, _):
                return LuasStrings.gettingDueTimes(trainStation)

            case .errorGettingDueTimes(_, let errorMessage):
                return errorMessage

            case .foundDueTimes(let trains, _):
                return LuasStrings.foundDueTimes(trains)

            case .updatingDueTimes(let trains, _):
                return LuasStrings.updatingDueTimes(trains)
        }
    }
}

public protocol AppStateChangeable {
    func didChange(to: MyState)
}

// WIP remove
public class AppState: ObservableObject {
    @Published public var state: MyState = .locationAuthorizationUnknown {
        didSet {
            changeable?.didChange(to: state)
        }
    }
    @Published public var isStationsModalPresented: Bool = false

    public var changeable: AppStateChangeable?

    public init() {}

    public init(state: MyState) {
        self.state = state
    }

    public func updateWithAnimation(to state: MyState) {
        withAnimation {
            DispatchQueue.main.async { [weak self] in
                self?.state = state
            }
        }
    }
}
