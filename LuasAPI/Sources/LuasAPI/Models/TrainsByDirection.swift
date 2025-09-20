//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public struct TrainsByDirection: Equatable, Sendable {

  // MARK: - Properties

  public let station: TrainStation
  public let inbound: [Train]
  public let outbound: [Train]
  public let message: String?  // XML API returns 'message'

  public init(
    station: TrainStation,
    inbound: [Train],
    outbound: [Train],
    message: String? = nil
  ) {
    self.station = station
    self.inbound = inbound
    self.outbound = outbound
    self.message = message
  }

  public func formatForShortcut(direction: Direction) -> String {

    var output = ""

    /// first add inbound trains...
    if direction == .inbound || direction == .both {
      format(trains: inbound, output: &output)
    }

    /// ... then add outbound
    if direction == .outbound || direction == .both {
      format(trains: outbound, output: &output)
    }

    return output.count > 0 ? output : "No trains found for \(station.name) LUAS stop.\n"
  }

  private func format(trains: [Train], output: inout String) {

    // group by destination
    let dictionary = Dictionary(
      grouping: trains,
      by: { (element: Train) in
        element.destination
      })

    for key in dictionary.keys {
      output += "LUAS to \(key) "

      var isFirst = true
      for train in dictionary[key] ?? [] {
        output += "\(isFirst == false ? " and " : "")" + train.destinationDueTimeDescription
        isFirst = false
      }

      if String(output.suffix(10)) == "is due now" {
        output += ".\n"
      } else {
        output += String(output.suffix(2) == " 1" ? " minute.\n" : " minutes.\n")
      }
    }
  }

  // MARK: - Computed Properties

  private static let cutoffSmall = 3
  private static let cutoffLarge = 6

  public var inboundHasOverflowSmall: Bool {
    inbound.count > Self.cutoffSmall
  }

  public var outboundHasOverflowSmall: Bool {
    outbound.count > Self.cutoffSmall
  }

  public var inboundHasOverflowLarge: Bool {
    inbound.count > Self.cutoffLarge
  }

  public var outboundHasOverflowLarge: Bool {
    outbound.count > Self.cutoffLarge
  }

  public var inboundNoOverflowSmall: [Train] {
    inboundHasOverflowSmall ? Array(inbound.prefix(upTo: Self.cutoffSmall)) : inbound
  }

  public var outboundNoOverflowSmall: [Train] {
    outboundHasOverflowSmall ? Array(outbound.prefix(upTo: Self.cutoffSmall)) : outbound
  }

  public var inboundNoOverflowLarge: [Train] {
    inboundHasOverflowLarge ? Array(inbound.prefix(upTo: Self.cutoffLarge)) : inbound
  }

  public var outboundNoOverflowLarge: [Train] {
    outboundHasOverflowLarge ? Array(outbound.prefix(upTo: Self.cutoffLarge)) : outbound
  }
}
