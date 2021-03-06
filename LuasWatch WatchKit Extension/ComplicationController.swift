//
//  Created by Roland Gropmair on 17/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

	// MARK: - Configure available complication families

	func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
		let descriptors = [CLKComplicationDescriptor(identifier: "luasImage", displayName: "LUAS Times", supportedFamilies:
														[.modularSmall,
														 .utilitarianSmall,
														 .circularSmall,
														 .extraLarge,
														 .graphicCorner,
														 .graphicCircular])]

		handler(descriptors)
	}

	// MARK: - Timeline Configuration

	func getSupportedTimeTravelDirections(for complication: CLKComplication,
										  withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
		handler([])
	}

	func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		handler(nil)
	}

	func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		handler(nil)
	}

	func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
		handler(.showOnLockScreen)
	}

	// MARK: - Timeline Population

	func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		// Call the handler with the current timeline entry
		handler(timelineEntry(for: complication.family))
	}

	func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int,
							withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
		// Call the handler with the timeline entries prior to the given date
		handler(nil)
	}

	func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int,
							withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
		// Call the handler with the timeline entries after to the given date
		handler(nil)
	}

	// MARK: - Placeholder Templates

	// swiftlint:disable:next cyclomatic_complexity
	func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		// This method will be called once per supported complication, and the results will be cached
		switch complication.family {

			case .modularSmall:
				let template = CLKComplicationTemplateModularSmallSimpleImage(imageProvider: standardImageProvider())
				handler(template)

			case .modularLarge:
//				assertionFailure("unsupported complication family")
				handler(nil)

			case .utilitarianSmall:
				let template = CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: standardImageProvider())
				handler(template)

			case .utilitarianSmallFlat:
//				assertionFailure("unsupported complication family")
				handler(nil)

			case .utilitarianLarge:
//				assertionFailure("unsupported complication family")
				handler(nil)

			case .circularSmall:
				let template = CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: standardImageProvider())
				handler(template)

			case .extraLarge:
				let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: standardImageProvider())
				handler(template)

			case .graphicCorner:
				let template = CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: graphicCornerImageProvider())
				handler(template)

			case .graphicBezel:
//				assertionFailure("unsupported complication family")
				handler(nil)

			case .graphicCircular:
				let template = CLKComplicationTemplateGraphicCircularImage(imageProvider: graphicCornerImageProvider())
				handler(template)

			case .graphicRectangular:
//				assertionFailure("unsupported complication family")
				handler(nil)

			case .graphicExtraLarge:
//				assertionFailure("unsupported complication family")
				handler(nil)

			@unknown default:
//				assertionFailure("unsupported complication family")
				handler(nil)

		}
	}

}

private extension ComplicationController {

	func standardImageProvider() -> CLKImageProvider {
		return CLKImageProvider(onePieceImage: UIImage(named: "Icon (Complication)")!)
	}

	func graphicCornerImageProvider() -> CLKFullColorImageProvider {
		return CLKFullColorImageProvider(fullColorImage: UIImage(named: "IconRound (Complication)")!)
	}

	// swiftlint:disable:next cyclomatic_complexity function_body_length
	func timelineEntry(for family: CLKComplicationFamily) -> CLKComplicationTimelineEntry? {

		switch family {
			case .modularSmall:
				let template = CLKComplicationTemplateModularSmallSimpleImage(imageProvider: standardImageProvider())
				return CLKComplicationTimelineEntry(date: Date(),
													complicationTemplate: template)

			case .modularLarge:
				assertionFailure("unsupported complication family")
				return nil

			case .utilitarianSmall:
				let template = CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: standardImageProvider())
				return CLKComplicationTimelineEntry(date: Date(),
													complicationTemplate: template)

			case .utilitarianSmallFlat:
				assertionFailure("unsupported complication family")
				return nil

			case .utilitarianLarge:
				assertionFailure("unsupported complication family")
				return nil

			case .circularSmall:
				let template = CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: standardImageProvider())
				return CLKComplicationTimelineEntry(date: Date(),
													complicationTemplate: template)

			case .extraLarge:
				let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: standardImageProvider())
				return CLKComplicationTimelineEntry(date: Date(),
													complicationTemplate: template)

			case .graphicCorner:
				let template = CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: graphicCornerImageProvider())
				return CLKComplicationTimelineEntry(date: Date(),
													complicationTemplate: template)

			case .graphicBezel:
				assertionFailure("unsupported complication family")
				return nil

			case .graphicCircular:
				let template = CLKComplicationTemplateGraphicCircularImage(imageProvider: graphicCornerImageProvider())
				return CLKComplicationTimelineEntry(date: Date(),
													complicationTemplate: template)

			case .graphicRectangular:
				assertionFailure("unsupported complication family")
				return nil

			case .graphicExtraLarge:
				assertionFailure("unsupported complication family")
				return nil

			@unknown default:
				assertionFailure("unsupported complication family")
				return nil
		}
	}
}
