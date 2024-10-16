//
//  Created by Roland Gropmair on 04/09/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import CoreLocation
import Foundation

// swiftlint:disable line_length
public struct LuasStrings {

  public static let noTrainsErrorMessage =
    NSLocalizedString("Couldn’t get any trains.", comment: "")

  public static let noTrainsFallbackExplanation =
    NSLocalizedString(
      "Either Luas is not operating, or there is a problem with the Luas website.", comment: "")

  public static let tooFarAway =
    NSLocalizedString(
      "Looks like the closest Luas station is quite far away.\n\n"
        + "Please try again later when you’re closer to the Dublin Area.",
      comment: "")

  public static func errorGettingDueTimes(station: String) -> String {
    NSLocalizedString(
      "Error getting due times for station \(station)",
      comment: "Error shown when network loading failed; with placeholder for station")
  }

  public static let errorNoInternet =
    NSLocalizedString(
      "Looks like your watch is not connected to the internet.\n\nPlease check your internet connection and try again.",
      comment: "")

  public static let locationServicesDisabled =
    NSLocalizedString("Error getting your location:\n\nLocation Services not enabled", comment: "")

  public static let locationAccessDenied =
    NSLocalizedString(
      "We are only able to find the closest station if you allow location services.\n\nPlease go to Settings -> Privacy -> Location Services to turn them on for LuasWatch.",
      comment: "")

  public static func gettingLocationAuthError(_ errorMessage: String) -> String {
    NSLocalizedString("Error getting your location:\n\n\(errorMessage)", comment: "")
  }

  public static let locationAuthorizationUnknown =
    NSLocalizedString(
      "Please grant location access so LuasWatch can find the closest LUAS stop.", comment: "")

  public static let gettingLocation =
    NSLocalizedString("Getting location...", comment: "")

  public static let gettingLocationOtherError =
    NSLocalizedString("Error getting your location:\n\nOther error", comment: "")

  public static let errorGettingStation =
    NSLocalizedString("Error finding station.\n\nPlease try again later.", comment: "")

  public static func gettingDueTimes(_ trainStation: TrainStation) -> String {
    NSLocalizedString("Getting times for \(trainStation.name)...", comment: "")
  }

  public static func foundDueTimes(_ trains: TrainsByDirection) -> String {
    NSLocalizedString("Found times: \(trains)", comment: "")
  }

  public static let loadingDueTimes = NSLocalizedString(
    "Loading...", comment: "Shown while loading data from internet")

  public static let switchingDirectionsNotAllowedForFinalStop = NSLocalizedString(
    "Cannot switch directions for final stops", comment: "")

  public static let switchingDirectionsNotAllowedForOnewayStop = NSLocalizedString(
    "Cannot switch directions for one-way stops", comment: "")

  public static func distance(station: TrainStation, distance: String) -> String {
    NSLocalizedString(
      "\(station.name) stop is \(distance) away",
      comment:
        "String indicating distance of this Luas station (in meters) - input1: station name; input2: distance string"
    )
  }

  public static let noTrains = NSLocalizedString(
    "No trains due", comment: "String shown when no trains in specified direction")

  public static let trainsLoading = NSLocalizedString(
    "Loading trains...", comment: "String shown when trains are loading for station")

  public static let locationDeniedFooter = NSLocalizedString(
    "Unable to determine closest station, because location access not granted or disabled.\nYou can still select a station manually.",
    comment:
      "Label shown when location access was denied by user, to explain why nearby stations won't work"
  )
}
// swiftlint:enable line_length
