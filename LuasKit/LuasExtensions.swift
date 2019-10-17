//
//  Created by Roland Gropmair on 17/10/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import SwiftUI

public extension UIColor {

	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")

		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}

	convenience init(rgb: Int) {
		self.init(
			red: (rgb >> 16) & 0xFF,
			green: (rgb >> 8) & 0xFF,
			blue: rgb & 0xFF
		)
	}

	static let luasRed = UIColor(rgb: 0xEE4251)
	static let luasGreen = UIColor(rgb: 0x00A666)
	static let luasPurple = UIColor(rgb: 0x5235D6)
}
