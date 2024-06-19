

import UIKit

class CalendarHelper {
    static let shared = CalendarHelper()
    let calendar = Calendar.current

    func startOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }

    func endOfMonth(date: Date) -> Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return calendar.date(byAdding: components, to: startOfMonth(date: date))!
    }

    func numberOfDaysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }

    func firstDayOfMonth(date: Date) -> Int {
        let firstDay = startOfMonth(date: date)
        return calendar.component(.weekday, from: firstDay) - 1
    }
}

