//
//  Created by Roland Gropmair on 02/11/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI

import LuasAPI
import LuasApp

struct LuasMainScreen {

  @EnvironmentObject var appModel: AppModel
  @State var isMenuPresented: Bool = false

  private static let trainStations = TrainStations()
}

extension LuasMainScreen: View {

  var body: some View {

    NavigationView {

      StationView()
        .sheet(isPresented: $isMenuPresented) {
          SidebarView(selectedStation: $appModel.selectedStation)
        }
        .toolbar {
          ToolbarItemGroup(placement: .topBarLeading) {
            Button("Menu") {
              isMenuPresented = true
            }
          }
        }
    }
  }
}
