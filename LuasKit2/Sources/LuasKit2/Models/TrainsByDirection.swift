//
//  Created by Roland Gropmair on 11/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

public struct TrainsByDirection {

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

  public func shortcutOutput(direction: Direction) -> String {
    var output = ""

    if direction == .inbound || direction == .both {
      output +=
        inbound
        .compactMap { $0.destinationDueTimeDescription + ".\n" }
        .joined()
    }

    if direction == .outbound || direction == .both {
      output +=
        outbound
        .compactMap { $0.destinationDueTimeDescription + ".\n" }
        .joined()
    }

    return output.count > 0 ? output : "No trains found for \(station.name) LUAS stop.\n"
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
