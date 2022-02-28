//
//  CalendarModel.swift
//  gantt-test
//
//  Created by Kai on 2022/2/25.
//

import Foundation

struct CalendarModel {
    var startDate: Date
    var endDate: Date
    
    private var calendar: Calendar {
        .current
    }
    
    func calendarItems() -> [CalendarItem] {
        var day = calendar.startOfDay(for: startDate)
        var items: [CalendarItem] = []
        let endOfDay = calendar.startOfDay(for: endDate)
        
        items.append(.init(date: day))
        
        while day < endOfDay {
            day = calendar.date(byAdding: .day, value: 1, to: day)!
            items.append(.init(date: day))
        }
        
        return items
    }
}

struct CalendarItem {
    var date: Date
}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

public extension Date {
    var startOfDay: Self {
        Calendar.current.startOfDay(for: self)
    }
    
    static func days(from fromDate: Date = Date().startOfDay, to date: Date) -> Int {
        if let days = Calendar.current.dateComponents([.day],
                                                   from: fromDate.startOfDay,
                                                   to: date.startOfDay).day {
            return days + 1
        }
        
        return 0
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
            return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
        }
        
    func daysInMonth() -> Int {
        Date.days(from: startOfMonth(), to: endOfMonth())
    }
}
