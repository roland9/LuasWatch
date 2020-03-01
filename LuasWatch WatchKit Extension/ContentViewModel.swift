//
//  Created by Roland Gropmair on 01.03.20.
//  Copyright © 2020 mApps.ie. All rights reserved.
//

import Foundation
import LuasKit

struct TrainViewModel {
	let destination: String
	let dueTime: String	// 'Due' or '8 mins' or '8'

	public var dueTimeDescription: String {
		return "\(destination.replacingOccurrences(of: "LUAS ", with: "")): " + (dueTime == "Due" ? "Due" : "\(dueTime) mins")
	}
}

enum TrainsViewModel {
	case none
	case one(TrainViewModel)
	case two(TrainViewModel, TrainViewModel)
	case three(TrainViewModel, TrainViewModel, TrainViewModel)
	case more(TrainViewModel, TrainViewModel, TrainViewModel)
}

struct ContentViewModel {
	let inbound:  TrainsViewModel
	let outbound: TrainsViewModel
}

extension ContentViewModel {
	static func create(trains: TrainsByDirection) -> ContentViewModel {

		return ContentViewModel(inbound: ContentViewModel.trainModel(trains: trains.inbound),
								outbound: ContentViewModel.trainModel(trains: trains.outbound))
	}

	fileprivate static func trainModel(trains: [Train]) -> TrainsViewModel {
		switch trains.count {
			case 0:
				return .none

			case 1:
				let model = TrainViewModel(destination: trains[0].destination,
										   dueTime: trains[0].dueTime)
				return .one(model)

			case 2:
				let mainModeal = TrainViewModel(destination: trains[0].destination,
											dueTime: trains[0].dueTime)
				let model2 = TrainViewModel(destination: trains[1].destination,
										dueTime: trains[1].dueTime)
				return .two(mainModeal, model2)

			case 3:
				let mainModel = TrainViewModel(destination: trains[0].destination,
									   dueTime: trains[0].dueTime)
				let model2 = TrainViewModel(destination: trains[1].destination,
										dueTime: trains[1].dueTime)
				let model3 = TrainViewModel(destination: trains[2].destination,
										dueTime: trains[2].dueTime)
				return .three(mainModel, model2, model3)

			default:
				let mainModel = TrainViewModel(destination: trains[0].destination,
										   dueTime: trains[0].dueTime)
				let model2 = TrainViewModel(destination: trains[1].destination,
										dueTime: trains[1].dueTime)
				let model3 = TrainViewModel(destination: trains[2].destination,
										dueTime: trains[2].dueTime)
				return .more(mainModel, model2, model3)
		}
	}
}
