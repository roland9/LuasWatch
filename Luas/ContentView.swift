//
//  ContentView.swift
//  Luas
//
//  Created by Roland Gropmair on 04/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI
import Combine

class Logs: Combine.ObservableObject, Identifiable {
	typealias PublisherType = PassthroughSubject<Void, Never>

	var didChange = PublisherType()

	var logEntries: [String] = [""] {
		didSet {
			didChange.send(())
		}
	}

	init(_ entries: [String]) {
		logEntries = entries
	}
}

struct ContentView: View {
	@ObservedObject var logs = Logs(["one", "two", "three"])

    var body: some View {
		List(logs.logEntries, id: \.self) { (log) in
			Text(log)
		}
    }
}

#if DEBUG
// swiftlint:disable:next type_name
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
