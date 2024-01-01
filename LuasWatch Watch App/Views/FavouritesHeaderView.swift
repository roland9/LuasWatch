//
//  Created by Roland Gropmair on 01/01/2024.
//  Copyright © 2024 mApps.ie. All rights reserved.
//

import SwiftUI

struct FavouritesHeaderView: View {

    var body: some View {
        HStack {
            Text("Favourites")
                .font(.subheadline)
                .frame(minHeight: 40)
            Spacer()
            Button(action: {
                #warning("WIP - add from list")
            }, label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 30)
            })
            .buttonStyle(.borderless)
        }
    }
}
