//
//  Created by Roland Gropmair on 03/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftData
import SwiftUI

struct AllStationsListView {
  @EnvironmentObject var appModel: AppModel
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State var stations: [TrainStation]

  private static let trainStations = TrainStations()
}

extension AllStationsListView: View {

  var body: some View {

    NavigationView(content: {

      ScrollView {
        NavigationLink(
          destination: stationsListView(
            stations: Self.trainStations.greenLineStations)
        ) {
          LineRow(route: .green, isHighlighted: false)
        }

        NavigationLink(
          destination: stationsListView(
            stations: Self.trainStations.redLineStations)
        ) {
          LineRow(route: .red, isHighlighted: false)
        }
      }
    })
    .navigationTitle("Add to favourites")
  }

  @ViewBuilder
  private func stationsListView(stations: [TrainStation]) -> some View {
    StationsModal(
      stations: stations,
      highlightedStation: appModel.highlightedStation,
      action: { station in

        if modelContext.doesFavouriteStationExist(shortCode: station.shortCode)
          == false
        {
          modelContext.insert(FavouriteStation(shortCode: station.shortCode))
        } else {
          myPrint("Favourite station already exists -> ignore")
        }

        DispatchQueue.main.async {
          dismiss()
        }
      }
    )
    .navigationTitle("Add to favourites")
  }
}

#if DEBUG

  #Preview("All Stations (green)") {

    AllStationsListView(stations: TrainStations().greenLineStations)
      .environmentObject(makeAppModel(state: .gettingLocation))
      .modelContainer(Previews().container)
  }

#endif
