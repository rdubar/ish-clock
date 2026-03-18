// ISH CLOCK version 1.3
// Copyright 1994-2026, Roger Dubar.
//
// This software is released under the MIT License.
// See the LICENSE file in the project root for more information.

import SwiftUI

struct ContentView: View {
    #if DEBUG
    private let useLongestPhraseDebugMode = false
    #else
    private let useLongestPhraseDebugMode = false
    #endif

    private let refreshIntervalSeconds: TimeInterval = 10

    private let phraseColors: [Color] = [
        Color(red: 0.93, green: 0.72, blue: 0.55),  // warm tan
        Color(red: 0.55, green: 0.80, blue: 0.62),  // sage green
        Color(red: 0.55, green: 0.70, blue: 0.92),  // sky blue
        Color(red: 0.95, green: 0.65, blue: 0.55),  // peach
        Color(red: 0.75, green: 0.60, blue: 0.90),  // lavender
        Color(red: 0.55, green: 0.82, blue: 0.82),  // teal
    ]

    var body: some View {
        TabView {
            TimelineView(.periodic(from: .now, by: refreshIntervalSeconds)) { context in
                VStack {
                    let date = displayedDate(from: context.date)

                    Text(IshClock.phrase(for: date))
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .minimumScaleFactor(0.58)
                        .foregroundStyle(phraseColor(for: date))
                }
                .padding()
            }

            VStack(spacing: 6) {
                Text("ISH CLOCK")
                    .font(.system(.headline, design: .rounded, weight: .semibold))

                Text("\u{00A9} Roger Dubar")
                    .font(.system(.footnote, design: .rounded))

                Text("1994-\(String(Calendar.current.component(.year, from: .now)))")
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.secondary)

                Text("MIT License")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .tabViewStyle(.page)
    }

    private func phraseColor(for date: Date) -> Color {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let seed =
            (components.year ?? 0) * 10_000_000 +
            (components.month ?? 0) * 100_000 +
            (components.day ?? 0) * 1_000 +
            (components.hour ?? 0) * 60 +
            (components.minute ?? 0)
        return phraseColors[abs(seed) % phraseColors.count]
    }

    private func displayedDate(from liveDate: Date) -> Date {
        guard useLongestPhraseDebugMode else {
            return liveDate
        }

        var components = DateComponents()
        components.hour = 23
        components.minute = 25
        components.second = 0
        return Calendar.current.date(from: components) ?? liveDate
    }
}
