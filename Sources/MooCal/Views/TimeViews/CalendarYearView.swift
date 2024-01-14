//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 1/13/24.
//

import SwiftUI

//@available(iOS 16.4, *)
public struct CalendarYearViewMoo<CustomView: View>: View {
    public var calendarMonths: [CalendarMonth]
    public var calendarDayView: CalendarDayView<CustomView>
    public var onSelection: ((CalendarDay) -> ())?
    
    public init(calendarMonths: [CalendarMonth], calendarDayView: CalendarDayView<CustomView>, onSelection: ( (CalendarDay) -> Void)? = nil) {
        self.calendarMonths = calendarMonths
        self.calendarDayView = calendarDayView
        self.onSelection = onSelection
    }

    public var body: some View {
        ForEach(calendarMonths) { calendarMonth in
            CalendarMonthView(calendarMonth: calendarMonth, calendarDayView: calendarDayView, onSelection: onSelection)
                .id(calendarMonth.id)
        }
    }
}
