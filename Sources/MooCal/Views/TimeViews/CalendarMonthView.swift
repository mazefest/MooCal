//
//  CalendarMonthView.swift
//  CalyKitTestApp
//
//  Created by Colby Mehmen on 10/19/23.
//

import SwiftUI

public struct CalendarMonthView<CustomView: View, HeaderView: View, DayOfWeekIndicatorView: View>: View {
    public var calendarMonth: CalendarMonth
    public var calendarHeaderView: CalendarMonthHeaderView<HeaderView>
    public var calendarDayView: CalendarDayView<CustomView>
    public var calendarDayOfWeekIndicatorView: CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView>
    public var onSelection: ((CalendarDay) -> ())?
    
    public init(calendarMonth: CalendarMonth, calendarHeaderView: CalendarMonthHeaderView<HeaderView>, calendarDayView: CalendarDayView<CustomView>, calendarDayOfWeekIndicatorView: CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView>, onSelection: ( (CalendarDay) -> Void)? = nil) {
        self.calendarMonth = calendarMonth
        self.calendarHeaderView = calendarHeaderView
        self.calendarDayView = calendarDayView
        self.calendarDayOfWeekIndicatorView = calendarDayOfWeekIndicatorView
        self.onSelection = onSelection
    }
    
    public var body: some View {
        VStack(spacing: 0.0) {
            headerView
            daysView
                .padding()
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        switch calendarHeaderView {
        case .custom(let customHeaderView):
            customHeaderView(calendarMonth)
        case .monthLabel:
            Text(calendarMonth.title)
                .bold()
        case .monthYearLabel:
            Text("\(calendarMonth.title) \(calendarMonth.year)")
                .bold()
        }
    }
    
    @ViewBuilder
    private var daysOfWeek: some View {
        ForEach(DayOfWeek.allCases) { day in
            switch self.calendarDayOfWeekIndicatorView {
            case .custom(let customCalendarDayOFWeekIndicatorView):
                customCalendarDayOFWeekIndicatorView(day)
            case .singleLetter:
                Text("\(day.letter)")
            case .abbreviated:
                Text("\(day.abbreviated)")
            }
        }
    }
    
    var trailingEmptyDayCount: Int {
        let d = (offSet + calendarMonth.days.count) % 7
        return (7 - d) % 7
    }
    
    public var offSet: Int {
        calendarMonth.startDate.monthStartOffset()
    }
    
    @ViewBuilder
    public var daysView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            daysOfWeek
            ForEach(0..<offSet) { i in
                RoundedRectangle(cornerRadius: 10.0)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.0))
            }
            
            // list all the days
            ForEach(calendarMonth.days) { i in
                Button {
                    onSelection?(i)
                } label: {
                    dayView(day: i)
                }
                .buttonStyle(.plain)
            }
            
            ForEach(0..<trailingEmptyDayCount) { i in
                Button(action: {
                    //
                }, label: {
                    RoundedRectangle(cornerRadius: 10.0)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray.opacity(0.0))
                })
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    public func dayView(day: CalendarDay) -> some View {
        switch calendarDayView {
        case .custom(let customView):
            customView(day)
            
        case .classic(let data):
            let filteredItems = data.filter({$0.date.isInDay(day.date)})
            ClassicCalendarDayView(day: day, items: filteredItems)
            
        case .numbered(let config):
            ClassicNumberedDayView(day: day, config: config)
        }
    }
    
}
