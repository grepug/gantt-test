//
//  GanttChartConfiguration.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

struct GanttChartConfiguration {
    var headerStyle: GanttCalendarHeaderStyle = .weeksAndDays
    var currentDate: Date = Date()
    var cycles: [GanttChartCycle] = []
    var items: [GanttChartItem]
    
    var showingLeadingFixedColumn = true
    
    var fixedHeaderHeight: CGFloat = 80
    var fixedColumnWidth: CGFloat = 100
    var bgCellHeight: CGFloat = 60
    var itemHeight: CGFloat = 40
    var widthPerDay: CGFloat = 30
    var extraWidthPerDay: CGFloat = 0
    
    var leadingCompensatedMonths = 0
    var trailingCompensatedMonths = 0
    
    var startDate: Date {
        items.map(\.startDate).min()!
    }
    
    var endDate: Date {
        items.map(\.endDate).max()!
    }
    
    var chartStartDate: Date
    var chartEndDate: Date
    
    private var bgCells: [GanttBgCell] = []
    
    init(items: [GanttChartItem]) {
        let startDate = items.map(\.startDate).min()!
        let endDate = items.map(\.endDate).max()!
        
        self.chartStartDate = Self.getChartStartDate(date: startDate, in: headerStyle)
        self.chartEndDate = Self.getCharEndDate(date: endDate)
        self.items = items
        self.bgCells = Self.bgCells(startDate: chartStartDate,
                                    endDate: chartEndDate,
                                    widthPerDay: widthPerDay,
                                    in: headerStyle)
    }
}

private extension GanttChartConfiguration {
    static func getChartStartDate(date: Date,
                                  in style: GanttCalendarHeaderStyle) -> Date {
        let startOfMonth = date.startOfMonth()
        
        switch style {
        case .weeksAndDays:
            return Self.firstWeekDay(of: startOfMonth)
        case .monthsAndDays:
            return Calendar.current.date(byAdding: .month,
                                         value: 0,
                                         to: startOfMonth)!
        }
    }
    
    static func getCharEndDate(date: Date) -> Date {
        let dateOfTrailingMonth = Calendar.current.date(byAdding: .month,
                                                        value: 0,
                                                        to: date)!

        return dateOfTrailingMonth.endOfMonth()
    }
    
    static func firstWeekDay(of date: Date) -> Date {
        var date = date
        var day = Calendar.current.dateComponents([.weekday], from: date).weekday!
        
        while day != 2 {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            day = Calendar.current.dateComponents([.weekday], from: date).weekday!
        }
        
        return date
    }
    
    static func bgCells(startDate: Date,
                        endDate: Date,
                        widthPerDay: CGFloat,
                        in style: GanttCalendarHeaderStyle) -> [GanttBgCell] {
        var date = startDate
        var cells: [GanttBgCell] = []
        
        while date < endDate {
            let days = date.daysInMonth()
            let width = CGFloat(days) * widthPerDay
            
            cells.append(.init(width: width, dateOfStart: date))
            
            switch style {
            case .monthsAndDays:
                date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
            case .weeksAndDays:
                date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
            }
        }
        
        return cells
    }
}

extension GanttChartConfiguration {
    func collectionViewNumberOfItem(in section: Int) -> Int {
        if section == 1 {
            return dayCells.count
        }
        
        return bgCells.count + 2
    }
    
    var collectionViewContentSize: CGSize {
        let width = fixedColumnWidth + CGFloat(numberOfDays) * widthPerDay
        let height = fixedHeaderHeight + CGFloat(items.count) * bgCellHeight
        
        return .init(width: width, height: height)
    }
    
    func todayPoint(in frame: CGRect, y: CGFloat = 0) -> CGPoint {
        let beforeDays = Date.days(from: chartStartDate, to: currentDate) - 1
        let x = CGFloat(beforeDays) * widthPerDay + fixedColumnWidth - frame.width / 2
        
        return .init(x: x, y: y)
    }
    
    func fixedHeaderTopCellConfiguration(at indexPath: IndexPath) -> UIContentConfiguration {
        let date = bgCell(at: indexPath).dateOfStart
        var config = UIListContentConfiguration.cell()
        let components = Calendar.current.dateComponents([.month, .year, .weekOfYear], from: date)
        let month = components.month!
        let year = components.year!
        
        config.directionalLayoutMargins.leading = 0
        config.textProperties.font = .preferredFont(forTextStyle: .headline)
        
        switch headerStyle {
        case .monthsAndDays:
            let yearText = month == 1 ? "\(year)年" : ""
            config.text = yearText + "\(month)月"
        case .weeksAndDays:
            let week = components.weekOfYear!
            let yearText = week == 1 ? "\(year + 1)年" : ""
            config.text = yearText + "第\(week)周"
        }
        
        return config
    }
    
    func chartItem(at indexPath: IndexPath) -> GanttChartItem {
        items[indexPath.section - 2]
    }
    
    func bgCell(at indexPath: IndexPath) -> GanttBgCell {
        bgCells[indexPath.item - 1]
    }
    
    func dayCell(at indexPath: IndexPath) -> GanttHeaderDayCell {
        dayCells[indexPath.item]
    }
    
    func cellType(at indexPath: IndexPath) -> GanttChartCellType {
        if indexPath.section == 0 && indexPath.item == 0 {
            return .fixedFirstCell
        }
        
        if indexPath.section == 0 {
            if indexPath.item == bgCells.count + 1 {
                return .todayVerticalLine
            }
            
            return .fixedHeaderCell
        }
        
        if indexPath.section == 1 {
            return .fixedHeaderDayCell
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
        let normalizedSection = section - 2
        let normalizedItem = item - (showingLeadingFixedColumn ? 1 : 0)
        let cellType = cellType(at: indexPath)
        
        switch cellType {
        case .fixedFirstCell:
            return .init(x: 0,
                         y: 0,
                         width: fixedColumnWidth,
                         height: fixedHeaderHeight)
        case .fixedHeaderCell:
            return .init(x: fixedColumnWidth + calculateLeadingBgCellWidth(at: normalizedItem),
                         y: 0,
                         width: bgCellWidth(at: normalizedItem),
                         height: fixedHeaderHeight / 2)
        case .fixedHeaderDayCell:
            let dayCell = dayCells[item]
            let width = widthPerDay + extraWidthPerDay
            
            return .init(x: fixedColumnWidth + dayCell.x - extraWidthPerDay / 2,
                         y: fixedHeaderHeight / 2,
                         width: width,
                         height: fixedHeaderHeight / 2)
        case .fixedColumnCell:
            return .init(x: 0,
                         y: bgCellOffsetY(inSection: normalizedSection),
                         width: fixedColumnWidth,
                         height: bgCellHeight)
        case .bgCell:
            return .init(x: fixedColumnWidth + calculateLeadingBgCellWidth(at: normalizedItem),
                         y: bgCellOffsetY(inSection: normalizedSection),
                         width: bgCellWidth(at: normalizedItem),
                         height: bgCellHeight)
        case .itemCell:
            return itemFrame(inSection: normalizedSection)
        case .todayVerticalLine:
            let beforeDays = Date.days(from: chartStartDate, to: currentDate) - 1
            let lineWidth: CGFloat = 3
            let x = CGFloat(beforeDays) * widthPerDay + fixedColumnWidth
            
            return .init(x: x + (widthPerDay / 2) - lineWidth,
                         y: fixedHeaderHeight,
                         width: lineWidth,
                         height: collectionViewContentSize.height - fixedHeaderHeight)
        }
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
    
    var dayCells: [GanttHeaderDayCell] {
        var date = chartStartDate
        var cells: [GanttHeaderDayCell] = []
        var x: CGFloat = 0
        
        while date < chartEndDate {
            cells.append(.init(x: x, date: date))
            
            switch headerStyle {
            case .monthsAndDays:
                date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
                x += widthPerDay * 7
            case .weeksAndDays:
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                x += widthPerDay
            }
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
