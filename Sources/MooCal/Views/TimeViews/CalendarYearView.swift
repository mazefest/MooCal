//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 1/13/24.
//

import SwiftUI

public struct CalendarMonthsView<CustomView: View, HeaderView: View, DayOfWeekIndicatorView: View>: View {
    public var calendarMonths: [CalendarMonth]
    public var calendarHeaderView: CalendarMonthHeaderView<HeaderView>
    public var calendarDayView: CalendarDayView<CustomView>
    public var calendarDayOfWeekIndicatorView: CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView>
    public var onSelection: ((CalendarDay) -> ())?
    
    public init(calendarMonths: [CalendarMonth], calendarHeaderView: CalendarMonthHeaderView<HeaderView>, calendarDayView: CalendarDayView<CustomView>, calendarDayOfWeekIndicatorView: CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView>, onSelection: ( (CalendarDay) -> Void)? = nil) {
        self.calendarMonths = calendarMonths
        self.calendarDayView = calendarDayView
        self.calendarHeaderView = calendarHeaderView
        self.calendarDayOfWeekIndicatorView = calendarDayOfWeekIndicatorView
        self.onSelection = onSelection
    }

    public var body: some View {
        ForEach(calendarMonths) { calendarMonth in
            CalendarMonthView(
                calendarMonth: calendarMonth,
                calendarHeaderView: calendarHeaderView,
                calendarDayView: calendarDayView, 
                calendarDayOfWeekIndicatorView: calendarDayOfWeekIndicatorView,
                onSelection: onSelection
            )
            .id(calendarMonth.id)
        }
    }
}
