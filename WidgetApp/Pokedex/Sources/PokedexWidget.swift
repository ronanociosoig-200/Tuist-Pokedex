//
//  PokedexWidget.swift
//  PokedexWidget
//
//  Created by ronan.ociosoig on 04/10/2023.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct PokedexWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time is now:")
            Text(entry.date, style: .time)

            Text("Pokedex Icon Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

@main
struct PokedexWidget: Widget {
    let kind: String = "PokedexWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PokedexWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("PokedexApp")
        .description("Shows an overview of your Pokemons")
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    PokedexWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}


//struct PokedexWidgetEntryView : View {
//    var entry: PokedexStatusProvider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//            Text("Favorite Emoji:")
//            Text(entry.status)
//        }
//    }
//}
//
//struct PokedexStatusEntry: TimelineEntry {
//    let date: Date
//    let status: String
//}
//
//struct PokedexStatusProvider: TimelineProvider {
//    func placeholder(in context: Context) -> PokedexStatusEntry {
//        PokedexStatusEntry(date: Date(), status: "🍔")
//    }
//    
//    func getSnapshot(in context: Context, completion: @escaping (PokedexStatusEntry) -> Void) {
//        // PokedexStatusEntry(date: .now, status: "🥲")
//    }
//    
//    typealias Entry = PokedexStatusEntry
//    
//    func getTimeline(in context: Context,
//                     completion: @escaping (Timeline<Entry>) -> Void) {
//        let date = Date()
//        let entry = PokedexStatusEntry(
//                    date: date,
//                    status: "🥳"
//                )
//
//                // Create a date that's 15 minutes in the future.
//                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
//
//                // Create the timeline with the entry and a reload policy with the date
//                // for the next update.
//                let timeline = Timeline(
//                    entries:[entry],
//                    policy: .after(nextUpdateDate)
//                )
//
//                // Call the completion to pass the timeline to WidgetKit.
//                completion(timeline)
//    }
//}
//
//@main
//struct PokedexWidget: Widget {
//    let kind: String = "PokedexWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: "com.pokedex.status",
//                            provider: PokedexStatusProvider()) { entry in
//            PokedexWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("Pokedex")
//        .description("Shows an overview of your Pokemons")
//        .supportedFamilies([.systemMedium])
//    }
//}
//
//#Preview(as: .systemMedium) {
//    PokedexWidget()
//} timeline: {
//    PokedexStatusEntry(date: .now, status: "🥲")
//    PokedexStatusEntry(date: .now, status: "😌")
//}
