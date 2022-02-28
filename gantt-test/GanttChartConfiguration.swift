//
//  GanttChartConfiguration.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

struct GanttChartConfiguration {
    var headerStyle: GanttCalendarHeaderStyle = .monthsAndDays
    var currentDate: Date = Date()
    var cycles: [GanttChartCycle] = []
    var items: [GanttChartItem] = []
    
    var showingLeadingFixedColumn = true
    
    var fixedHeaderHeight: CGFloat = 80
    var fixedColumnWidth: CGFloat = 100
    var bgCellHeight: CGFloat = 60
    var itemHeight: CGFloat = 40
    var widthPerDay: CGFloat = 10
    
    var leadingCompensatedMonths = 1
    var trailingCompensatedMonths = 1
    
    var startDate: Date {
        items.map(\.startDate).min()!
    }
    
    var endDate: Date {
        items.map(\.endDate).max()!
    }
    
    var chartStartDate: Date {
        let startOfMonth = startDate.startOfMonth()
        
        return Calendar.current.date(byAdding: .month,
                                     value: -leadingCompensatedMonths,
                                     to: startOfMonth)!
    }
    
    var chartEndDate: Date {
        let dateOfTrailingMonth = Calendar.current.date(byAdding: .month,
                                                        value: trailingCompensatedMonths,
                                                        to: endDate)!

        return dateOfTrailingMonth.endOfMonth()
    }
}

enum GanttCalendarHeaderStyle {
    case weeksAndDays, monthsAndDays
}

enum GanttChartCellType: String, CaseIterable {
    case fixedFirstCell,
         fixedHeaderCell,
         fixedColumnCell,
         bgCell,
         itemCell
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
}

struct GanttBgCell {
    var width: CGFloat
    var dateOfStart: Date
}

extension GanttChartConfiguration {
    func collectionViewNumberOfItem(in section: Int) -> Int {
        if section == 0 {
            return bgCells.count + 1
        }
        
        return bgCells.count + 2
    }
    
    var collectionViewContentSize: CGSize {
        let width = fixedColumnWidth + CGFloat(numberOfDays) * widthPerDay
        let height = fixedHeaderHeight + CGFloat(items.count) * bgCellHeight
        
        return .init(width: width, height: height)
    }
    
    func chartItem(at indexPath: IndexPath) -> GanttChartItem {
        items[indexPath.section - 1]
    }
    
    func cellType(at indexPath: IndexPath) -> GanttChartCellType {
        if indexPath.section == 0 && indexPath.item == 0 {
            return .fixedFirstCell
        }
        
        if indexPath.section == 0 {
            return .fixedHeaderCell
        }
        
        if indexPath.item == 0 {
            return .fixedColumnCell
        }
        
        if indexPath.item - 1 < bgCells.count {
            return .bgCell
        }
        
        return .itemCell
    }
    
    func cellFrame(at indexPath: IndexPath) -> CGRect {
        let section = indexPath.section
        let item = indexPath.item
        let normalizedSection = section - 1
        let normalizedItem = item - (showingLeadingFixedColumn ? 1 : 0)
        
        if section == 0 && item == 0 {
            return .init(x: 0,
                         y: 0,
                         width: fixedColumnWidth,
                         height: fixedHeaderHeight)
        }
        
        if section == 0 {
            return .init(x: fixedColumnWidth + calculateLeadingBgCellWidth(at: normalizedItem),
                         y: 0,
                         width: bgCellWidth(at: normalizedItem),
                         height: fixedHeaderHeight)
        }
        
        if item == 0 {
            return .init(x: 0,
                         y: bgCellOffsetY(inSection: normalizedSection),
                         width: fixedColumnWidth,
                         height: bgCellHeight)
        }
        
        if normalizedItem < bgCells.count {
            return .init(x: fixedColumnWidth + calculateLeadingBgCellWidth(at: normalizedItem),
                         y: bgCellOffsetY(inSection: normalizedSection),
                         width: bgCellWidth(at: normalizedItem),
                         height: bgCellHeight)
        }
        
        return itemFrame(inSection: normalizedSection)
    }
    
}

private extension GanttChartConfiguration {
    func calculateLeadingBgCellWidth(at index: Int) -> CGFloat {
        var width = CGFloat.zero
        
        for i in 0..<index {
            width += bgCellWidth(at: i)
        }
        
        return width
    }
    
    func itemFrame(inSection index: Int) -> CGRect {
        let item = items[index]
        let beforeDays = Date.days(from: chartStartDate, to: item.startDate) - 1
        let x: CGFloat = widthPerDay * CGFloat(beforeDays) + fixedColumnWidth
        let y: CGFloat = bgCellOffsetY(inSection: index) + (bgCellHeight - itemHeight) / 2

        return .init(x: x,
                     y: y,
                     width: itemWidth(inSection: index),
                     height: itemHeight)
    }
    
    func bgCellOffsetY(inSection index: Int) -> CGFloat {
        var y: CGFloat = fixedHeaderHeight
        y += CGFloat(index) * bgCellHeight
        
        return y
    }
    
    func itemWidth(inSection index: Int) -> CGFloat {
        let item = items[index]
        let days = CGFloat(Date.days(from: item.startDate, to: item.endDate))
        
        switch headerStyle {
        case .monthsAndDays: return widthPerDay * days
        case .weeksAndDays: return widthPerDay * days
        }
    }
    
    var numberOfDays: Int {
        Date.days(from: chartStartDate, to: chartEndDate)
    }
    
    var bgCells: [GanttBgCell] {
        var date = chartStartDate
        var cells: [GanttBgCell] = []
        
        while date < chartEndDate {
            let days = date.daysInMonth()
            let width = CGFloat(days) * widthPerDay
            
            cells.append(.init(width: width, dateOfStart: date))
            
            date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        }
        
        return cells
    }
    
    func bgCellWidth(at index: Int = 0) -> CGFloat {
        switch headerStyle {
        case .weeksAndDays: return widthPerDay * 7
        case .monthsAndDays: return bgCells[index].width
        }
    }
}
