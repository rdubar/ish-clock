//
//  IshClockComplication.swift
//  IshClockComplication
//
//  Created by Roger Dubar on 17/03/2026.
//

import WidgetKit
import SwiftUI

struct IshTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> IshTimelineEntry {
        IshTimelineEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (IshTimelineEntry) -> Void) {
        completion(IshTimelineEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<IshTimelineEntry>) -> Void) {
        let now = Date.now
        let calendar = Calendar.current

        // One entry per minute for the next hour
        var entries: [IshTimelineEntry] = []
        for offset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: offset, to: now) {
                entries.append(IshTimelineEntry(date: entryDate))
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct IshTimelineEntry: TimelineEntry {
    let date: Date
}

struct IshComplicationView: View {
    var entry: IshTimelineEntry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryInline:
            Text(shortPhrase(for: entry.date))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        case .accessoryCorner:
            Text(shortPhrase(for: entry.date))
                .font(.system(.caption, design: .rounded, weight: .medium))
                .lineLimit(2)
                .minimumScaleFactor(0.4)
                .widgetCurvesContent()
        case .accessoryRectangular:
            Text(IshClock.phrase(for: entry.date))
                .font(.system(.caption, design: .rounded, weight: .medium))
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
        case .accessoryCircular:
            VStack(spacing: 1) {
                Text("ish")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                Text(shortHour(for: entry.date))
                    .font(.system(.caption2, design: .rounded))
            }
        default:
            Text(IshClock.phrase(for: entry.date))
                .font(.system(.caption2, design: .rounded))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.4)
        }
    }

    private func shortPhrase(for date: Date) -> String {
        let full = IshClock.phrase(for: date)
        // Remove "It is about " prefix for compact slots
        if full.hasPrefix("It is about ") {
            return String(full.dropFirst(12))
        }
        return full
    }

    private func shortHour(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        let h12 = ((hour + 11) % 12) + 1
        let words = ["one", "two", "three", "four", "five", "six",
                     "seven", "eight", "nine", "ten", "eleven", "twelve"]
        return words[h12 - 1]
    }
}

struct IshClockComplication: Widget {
    let kind = "IshClockComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: IshTimelineProvider()) { entry in
            IshComplicationView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Ish Clock")
        .description("The approximate time in words.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCorner,
            .accessoryRectangular,
            .accessoryCircular,
        ])
    }
}

#Preview(as: .accessoryRectangular) {
    IshClockComplication()
} timeline: {
    IshTimelineEntry(date: .now)
}
