import WidgetKit
import SwiftUI

struct QuoteWidgetEntry: TimelineEntry {
    let date: Date
    let quote: Quote?
}

struct QuoteWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteWidgetEntry {
        QuoteWidgetEntry(date: Date(), quote: Quote(text: "Sample Quote", author: "Sample Author"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteWidgetEntry) -> Void) {
        let entry = QuoteWidgetEntry(date: Date(), quote: Quote(text: "Sample Quote", author: "Sample Author"))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteWidgetEntry>) -> Void) {
        // TODO: Implement actual quote fetching from Core Data
        let entry = QuoteWidgetEntry(date: Date(), quote: Quote(text: "Sample Quote", author: "Sample Author"))
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct QuoteWidgetEntryView: View {
    var entry: QuoteWidgetEntry
    
    var body: some View {
        if let quote = entry.quote {
            VStack(alignment: .leading, spacing: 4) {
                Text(quote.text)
                    .font(.system(size: 14))
                    .lineLimit(3)
                
                Text("- \(quote.author)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding()
        } else {
            Text("No quote available")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

@main
struct QuoteWidget: Widget {
    let kind: String = "QuoteWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteWidgetProvider()) { entry in
            QuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote Widget")
        .description("Display your favorite quotes on your lockscreen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
} 