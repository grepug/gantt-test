//
//  gantt_test_Tests.swift
//  gantt-test Tests
//
//  Created by Kai on 2022/2/28.
//

@testable import gantt_test
import XCTest

class gantt_test_Tests: XCTestCase {
    func test_calendarItems_count_is_correct_tommorrow() throws {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        let calendarModel = CalendarModel(startDate: .now,
                                          endDate: tomorrow)
        let calendarItems = calendarModel.calendarItems()
        
        XCTAssertTrue(calendarItems.count == 2)
    }
    
    func test_calendarItems_count_is_correct() throws {
        let date1 = "2022-01-01 12:00:00".toDate()!
        let date2 = "2022-02-28 13:00:00".toDate()!
        
        let calendarModel = CalendarModel(startDate: date1, endDate: date2)
        let calendarItems = calendarModel.calendarItems()
        
        XCTAssertEqual(calendarItems.count, 59)
    }
    
    func test_leading_and_trailing_date_is_correct() throws {
        let date1 = "2022-01-10 12:00:00".toDate()!
        let date2 = "2022-02-15 13:00:00".toDate()!
        
        let config = GanttChartConfiguration(items: [
            .init(startDate: date1, endDate: date2, title: "", progress: 0, color: .systemPink)
        ])
        
        XCTAssertEqual(config.startDate, date1)
        XCTAssertEqual(config.endDate, date2)
        XCTAssertEqual(config.chartStartDate, "2021-12-01 00:00:00".toDate()!)
        XCTAssertEqual(config.chartEndDate, "2022-03-31 00:00:00".toDate()!)
    }
    
    func test_custom_leading_and_trailing_date_is_correct() throws {
        let date1 = "2022-01-10 12:00:00".toDate()!
        let date2 = "2022-02-15 13:00:00".toDate()!
        
        let config = GanttChartConfiguration(items: [
            .init(startDate: date1, endDate: date2, title: "", progress: 0, color: .systemPink)
        ], leadingCompensatedMonths: 2, trailingCompensatedMonths: 3)
        
        XCTAssertEqual(config.startDate, date1)
        XCTAssertEqual(config.endDate, date2)
        XCTAssertEqual(config.chartStartDate, "2021-11-01 00:00:00".toDate()!)
        XCTAssertEqual(config.chartEndDate, "2022-05-31 00:00:00".toDate()!)
    }
    
    func test_bg_cell_widths_is_correct() throws {
        let date1 = "2022-01-10 12:00:00".toDate()!
        let date2 = "2022-02-15 13:00:00".toDate()!
        
        let config = GanttChartConfiguration(items: [
            .init(startDate: date1, endDate: date2, title: "", progress: 0, color: .systemPink)
        ], leadingCompensatedMonths: 1, trailingCompensatedMonths: 1)
        
//        XCTAssertEqual(config.bgCellWidths.count, 4)
//        XCTAssertEqual(date1.daysInMonth(), 31)
//        XCTAssertEqual(date2.daysInMonth(), 28)
//        XCTAssertEqual(config.bgCellWidths[0], config.widthPerDay * 31)
//        XCTAssertEqual(config.bgCellWidths[2], config.widthPerDay * 28)
//        XCTAssertEqual(config.bgCellWidth(at: 0), config.widthPerDay * 31)
//        XCTAssertEqual(config.bgCellWidth(at: 1), config.widthPerDay * 31)
//        XCTAssertEqual(config.bgCellWidth(at: 2), config.widthPerDay * 28)
//        XCTAssertEqual(config.bgCellWidth(at: 3), config.widthPerDay * 31)
    }
    
    func test_days_from_to_is_correct() throws {
        let date1 = "2022-01-01 12:00:00".toDate()!
        let date2 = "2022-01-02 13:00:00".toDate()!
        
        let days = Date.days(from: date1, to: date2)
        
        XCTAssertEqual(days, 2)
    }
    
    func test_date_comopnent() throws {
        let date1 = "2022-01-01 12:00:00".toDate()!
        let date2 = "2022-02-28 12:00:00".toDate()!
        let date3 = "2020-02-01 12:00:00".toDate()!
        let date4 = "2020-12-01 12:00:00".toDate()!
        
        XCTAssertEqual(Calendar.current.dateComponents([.month], from: date1).month, 1)
        XCTAssertEqual(Calendar.current.dateComponents([.month], from: date2).month, 2)
        XCTAssertEqual(Calendar.current.dateComponents([.day], from: date1).day, 1)
        XCTAssertEqual(Calendar.current.dateComponents([.day], from: date2).day, 28)
        XCTAssertEqual(date1.daysInMonth(), 31)
        XCTAssertEqual(date2.daysInMonth(), 28)
        XCTAssertEqual(date3.daysInMonth(), 29)
        XCTAssertEqual(date4.daysInMonth(), 31)
    }
}
