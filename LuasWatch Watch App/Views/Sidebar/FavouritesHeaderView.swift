//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import LuasAPI
import LuasApp
import SwiftUI

struct FavouritesHeaderView {

  @Environment(\.modelContext) private var modelContext

  @State var isStationsModalPresented = false
}

extension FavouritesHeaderView: View {

  var body: some View {
    HStack {
      Text("Favourites")
        .font(.subheadline)
        .frame(minHeight: 40)
      Spacer()
      Button(
        action: {
          isStationsModalPresented = true
        },
        label: {
          Image(systemName: "plus.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 30)
        }
      )
      .buttonStyle(.borderless)
      .sheet(
        isPresented: $isStationsModalPresented,
        content: {
          AllStationsListView(stations: TrainStations.sharedFromFile.greenLineStations)
        })
    }
  }
}

#Preview("HeaderView") {
  FavouritesHeaderView()
    .modelContainer(Previews().container)
}
