//
//  Created by Roland Gropmair on 29/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import SwiftUI
import LuasKitIOS

#if DEBUG
// swiftlint:disable:next type_name
struct Preview_Buttons: PreviewProvider {

    static var previews: some View {

        Group {

            VStack {
                NavigationLink(destination: LuasView()) {
                    VStack {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Green Line Stations")
                    }
                }.buttonStyle(ModalButton(backgroundColor: Color("LuasPurpleColor")))

                NavigationLink(destination: LuasView()) {
                    VStack {
                        Image(systemName: "arrow.right.arrow.left")
                        Text("Red Line Stations")
                    }
                }.buttonStyle(ModalButton(backgroundColor: Color("LuasPurpleColor")))

                NavigationLink(destination: LuasView()) {
                    VStack {
                        Image(systemName: "location")
                        Text("Closest Station")
                    }
                }.buttonStyle(ModalButton(backgroundColor: Color("LuasPurpleColor")))
            }
        }
    }
}
#endif
