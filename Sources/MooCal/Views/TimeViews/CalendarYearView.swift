//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 1/13/24.
//

import SwiftUI

public struct CalendarYearViewMoo<CustomView: View, HeaderView: View>: View {
    public var calendarMonths: [CalendarMonth]
    public var calendarHeaderView: CalendarMonthHeaderView<HeaderView>
    public var calendarDayView: CalendarDayView<CustomView>
    public var onSelection: ((CalendarDay) -> ())?
    
    public init(calendarMonths: [CalendarMonth], calendarHeaderView: CalendarMonthHeaderView<HeaderView>, calendarDayView: CalendarDayView<CustomView>, onSelection: ( (CalendarDay) -> Void)? = nil) {
        self.calendarMonths = calendarMonths
        self.calendarDayView = calendarDayView
        self.calendarHeaderView = calendarHeaderView
        self.onSelection = onSelection
    }

    public var body: some View {
        ForEach(calendarMonths) { calendarMonth in
            CalendarMonthView(
                calendarMonth: calendarMonth,
                calendarHeaderView: calendarHeaderView,
                calendarDayView: calendarDayView,
                onSelection: onSelection
            )
            .id(calendarMonth.id)
        }
    }
}
