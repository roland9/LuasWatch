//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftData
import SwiftUI

struct StationTimesView: View {

  @Environment(\.modelContext) private var modelContext

  @Binding var direction: Direction

  let trainStation: TrainStation
  let trains: TrainsByDirection?
}

extension StationTimesView {

  var body: some View {

    VStack {

      Text(trainStation.name)
        .font(.title3)
        .frame(height: 10)
        .padding(.bottom)

      if let trains {
        timetableView(for: trains, direction: direction)

      } else {

        // no cachedTrains: we're loading that station for the first time
        TrainsViewLoading()
      }

      Spacer()
    }
  }

  @ViewBuilder
  fileprivate func timetableView(
    for trains: TrainsByDirection,
    direction: Direction
  ) -> some View {

    if trains.station.allowsSwitchingDirection {

      switch direction {

      case .inbound:
        if trains.inbound.isEmpty {

          NoTrainsView()
            .timeTableStyle()

        } else {
          SimpleTimetableView(
            trainsByDirection: trains, direction: .inbound)
        }

      case .outbound:
        if trains.outbound.isEmpty {

          NoTrainsView()
            .timeTableStyle()

        } else {
          SimpleTimetableView(
            trainsByDirection: trains, direction: .outbound)
        }

      case .both:
        DoubleTimetableView(
          trainsByDirection: trains)
      }

    } else {

      // we have a .terminal or .oneway station -> only show the inbound or outbound trains
      if !trains.inbound.isEmpty {

        SimpleTimetableView(
          trainsByDirection: trains, direction: .inbound)

      } else if !trains.outbound.isEmpty {

        SimpleTimetableView(
          trainsByDirection: trains, direction: .outbound)

      } else {

        NoTrainsView()
          .timeTableStyle()
      }

    }
  }
}
