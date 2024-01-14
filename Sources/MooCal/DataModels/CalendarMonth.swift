//
//  CalendarMonth.swift
//  CalyKitTestApp
//
//  Created by Colby Mehmen on 10/19/23.
//

import Foundation

public struct CalendarMonth {
    public var id = UUID()
    public var startDate: Date
    public var days: [CalendarDay]
    
    public var title: String {
        startDate.descriptor(.month)
    }
    
    public var startOfMonthOffset: Int {
        return startDate.monthStartOffset()
    }
    
    public var endOfMonthOffset: Int {
        return startDate.monthEndOffset()
    }
    
    static public func createCalendarMonth(fromMonthStartDate date: Date, data: [CalendarData]) -> CalendarMonth {
        let allDatesInCurrentMonth = date.getAllDatesInMonth()
        var days: [CalendarDay] = []
        for date in allDatesInCurrentMonth {
            days.append(.init(date: date, data: data.filter({$0.date.isInDay(date)})))
        }
        return .init(startDate: date, days: days)
    }
}

extension CalendarMonth: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CalendarMonth: Identifiable {
    static public func == (lhs: CalendarMonth, rhs: CalendarMonth) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CalendarMonth {
    static public func createCalendarMonths(fromMonthStartDates dates: [Date], data: [CalendarData]) -> [CalendarMonth] {
        return dates.compactMap({createCalendarMonth(fromMonthStartDate: $0, data: data)})
    }
    
    static public func createCalendarMonths(fromMonthStartDates dates: [Date], data: [CalendarData], completion: @escaping ( [CalendarMonth] ) -> ()) {
        let months = dates.compactMap({createCalendarMonth(fromMonthStartDate: $0, data: data)})
        completion(months)
    }
}
