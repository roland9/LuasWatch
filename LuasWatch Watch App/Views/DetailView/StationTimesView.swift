//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasKit
import SwiftData
import SwiftUI

struct StationTimesView: View {

  @Environment(\.modelContext) private var modelContext

  @State private var direction: Direction = .both

  let trainStation: TrainStation
  let trains: TrainsByDirection?
}

extension StationTimesView {

  var body: some View {

    NavigationStack {

      VStack {
        Text(trainStation.name)
          .font(.title3)
          .padding(.bottom)

        Spacer()

        if let trains {

          timetableView(for: trains)

        } else {

          // no cachedTrains: we're loading that station for the first time
          TrainsViewLoading()
            .timeTableStyle()
        }
      }

      .onAppear {
        direction = modelContext.directionConsideringStationType(for: trainStation.shortCode)
      }

      .toolbar {
        StationToolbar(
          direction: $direction,
          trainStation: trainStation)
      }
    }
  }

  @ViewBuilder
  fileprivate func timetableView(for trains: TrainsByDirection) -> some View {

    if trains.trainStation.allowsSwitchingDirection {

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
