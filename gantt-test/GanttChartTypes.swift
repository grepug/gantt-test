//
//  GanttChartTypes.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

enum GanttCalendarHeaderStyle: CaseIterable {
    case weeksAndDays, monthsAndDays
    
    var text: String {
        switch self {
        case .weeksAndDays: return "周视图"
        case .monthsAndDays: return "月视图"
        }
    }
}

enum GanttChartCellType: String, CaseIterable {
    case fixedFirstCell,
         fixedHeaderCell,
         fixedHeaderDayCell,
         fixedColumnCell,
         bgCell,
         itemCell,
         itemLabelCell
}

enum GattCharSection {
    case fixedHeader, content
}

struct GanttChartCycle {
    var startDate: Date
    var endDate: Date
}

struct GanttChartItem: Identifiable {
    var id = UUID()
    var startDate: Date
    var endDate: Date
    var title: String
    var progress: Double
    var color: UIColor
    
    var font = UIFont.preferredFont(forTextStyle: .body)
    
    var titleWidth: CGFloat {
        title.widthOfString(usingFont: font)
    }
}

struct GanttBgCell {
    var width: CGFloat
    var dateOfStart: Date
}

struct GanttHeaderDayCell {
    var x: CGFloat
    var date: Date
    
    var day: Int {
        Calendar.current.dateComponents([.day], from: date).day!
    }
}
