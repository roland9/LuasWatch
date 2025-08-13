//
//  Created by Roland Gropmair on 10/02/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftData
import SwiftUI

struct StationTimesView: View {

  @EnvironmentObject private var appModel: AppModel
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
          .font(.largeTitle)
          .padding(.bottom)

        if let trains {

          timetableView(for: trains)

          if let userLocation = appModel.latestLocation {
            ClosestStationsView(userLocation: userLocation)
          } else {
            Text("Location unavailable. Please enable location services to see nearby stations.")
              .font(.subheadline)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
          }

        } else {

          // no cachedTrains: we're loading that station for the first time
          TrainsViewLoading()
            .timeTableStyle()
        }
        Spacer()
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

    HStack {
      Text("Destination")
        .font(.title2)
      Spacer()
      Text("Minutes")
        .font(.title2)
    }
    .padding(.horizontal, 26)
    .padding(.bottom, -14)

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
