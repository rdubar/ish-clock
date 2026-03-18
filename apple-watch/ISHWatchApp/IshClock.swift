// ISH CLOCK version 1.3
// Copyright 1994-2026, Roger Dubar.
//
// This software is released under the MIT License.
// See the LICENSE file in the project root for more information.

import Foundation

struct IshClock {
    static func phrase(for date: Date = .now, calendar: Calendar = .current) -> String {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        return phrase(hour: hour, minute: minute, second: second)
    }

    static func phrase(hour: Int, minute: Int, second: Int = 0) -> String {
        let dayPart = daytime(hour: hour)

        var adjustedHour = hour % 12
        var adjustedMinute = minute

        if adjustedMinute > 57 && second > 30 {
            adjustedMinute += 1
        }

        if adjustedMinute >= 60 {
            adjustedMinute = 0
            adjustedHour += 1
        }

        if adjustedMinute > 33 {
            adjustedHour += 1
        }

        adjustedHour = ((adjustedHour + 11) % 12) + 1

        return "It is about \(ishTime(hour: adjustedHour, minute: adjustedMinute))\(dayPart)."
    }

    private static func number(_ value: Int) -> String {
        let words = [
            "one", "two", "three", "four", "five", "six",
            "seven", "eight", "nine", "ten", "eleven", "twelve"
        ]

        guard value > 0, value <= words.count else {
            return String(value)
        }

        return words[value - 1]
    }

    private static func bitTime(minute: Int) -> String {
        if minute <= 7 || minute > 53 { return "five minutes" }
        if minute <= 12 || minute > 48 { return "ten minutes" }
        if minute <= 17 || minute > 43 { return "quarter" }
        if minute <= 23 || minute > 38 { return "twenty minutes" }
        if minute <= 28 || minute > 33 { return "twenty-five minutes" }
        return "twenty-five minutes"
    }

    private static func ishTime(hour: Int, minute: Int) -> String {
        let hourWord = number(hour)

        if minute <= 3 || minute > 57 {
            return "\(hourWord) o'clock"
        }

        if minute <= 33 && minute > 28 {
            return "half past \(hourWord)"
        }

        let direction = minute < 30 ? "past" : "to"
        let minuteWord = bitTime(minute: minute)
        return "\(minuteWord) \(direction) \(hourWord)"
    }

    private static func daytime(hour: Int) -> String {
        if hour == 0 || hour >= 22 { return " at night" }
        if hour < 12 { return " in the morning" }
        if hour <= 17 { return " in the afternoon" }
        return " in the evening"
    }
}
