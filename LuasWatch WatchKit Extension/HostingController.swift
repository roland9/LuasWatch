//
//  Created by Roland Gropmair on 17/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<AnyView> {

	override var body: AnyView {
		// swiftlint:disable:next force_cast
		let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate

		return AnyView(LuasView()
			.environmentObject(extensionDelegate.appState))
	}
}
