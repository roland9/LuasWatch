//
//  Created by Roland Gropmair on 04/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftData
import SwiftUI

extension ModelContext {

  func doesFavouriteStationExist(shortCode: String) -> Bool {

    favouriteStation(shortCode: shortCode) != nil
  }

  func favouriteStation(shortCode: String) -> FavouriteStation? {
    let descriptor = FetchDescriptor<FavouriteStation>(
      predicate: #Predicate {
        $0.shortCode == shortCode
      })

    return try? fetch(descriptor).first
  }

  func toggleFavouriteStation(shortCode: String) {

    if let favourite = favouriteStation(shortCode: shortCode) {
      delete(favourite)
    } else {
      insert(FavouriteStation(shortCode: shortCode))
    }
  }

  internal func direction(for shortCode: String) throws -> [StationDirection] {

    let descriptor = FetchDescriptor<StationDirection>(
      predicate: #Predicate {
        $0.shortCode == shortCode
      })

    return try fetch(descriptor)
  }

  func directionConsideringStationType(for shortCode: String) -> Direction {

    guard let station = TrainStations().station(shortCode: shortCode) else {
      return .both
    }

    if station.isFinalStop || station.stationType == .oneway {
      return .both  // because we're not sure whether API returns the trains in inbound or outbound array
    } else {

      // only now that we checked the stationType, we check the DB
      if let obj = try? direction(for: shortCode).first {
        return obj.direction
      } else {
        return .both
      }
    }
  }

  func createOrUpdate(shortCode: String, to direction: Direction) {

    if let station = try? self.direction(for: shortCode).first {
      station.direction = direction
      return
    }

    insert(StationDirection(shortCode: shortCode, direction: direction))
  }
}
