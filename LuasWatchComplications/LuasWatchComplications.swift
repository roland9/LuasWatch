//
//  Created by Roland Gropmair on 14/05/2023.
//  Copyright © 2023 mApps.ie. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct LuasWatchComplicationsEntryView : View {
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
            case .accessoryInline:
                Image("Icon (Complication)")
                    .resizable()
                    .containerBackground(.black, for: .widget)

            case .accessoryCorner:
                Image("IconComplication91.2")
                    .resizable()
                    .containerBackground(.black, for: .widget)

            case .accessoryCircular:
                Image("IconComplication120")
                    .resizable()
                    .containerBackground(.black, for: .widget)

            case .accessoryRectangular:
                Image("Icon (Complication)")
                    .resizable()
                    .containerBackground(.black, for: .widget)

            @unknown default:
                // unknown widgetFamily
                Text("LuasWatch")
                    .containerBackground(.black, for: .widget)
        }
    }
}

@main
struct LuasWatchComplications: Widget {
    let kind: String = "LuasWatchComplications"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            LuasWatchComplicationsEntryView()
        }
        .configurationDisplayName("LUAS Times")
        .description("Show departure times of the closest Luas station.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
    }
}

struct LuasWatchComplications_Previews: PreviewProvider {
    static var previews: some View {

        LuasWatchComplicationsEntryView()
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("accessory circular")

        LuasWatchComplicationsEntryView()
            .previewContext(WidgetPreviewContext(family: .accessoryCorner))
            .previewDisplayName("accessory corner")
    }
}
