//
//  File.swift
//  
//
//  Created by Colby Mehmen on 1/13/24.
//

import SwiftUI

public enum CalendarDayView<CustomView: View> {
    case custom((CalendarDay) -> (CustomView))
    case classic([any ClassicCalendarData])
    case numbered(ClassicNumberedDayViewConfig)
}

// when using an enum without a `HeaderView` type (such as cusom), the compiler still needs to infer the `HeaderView` Type so that is why it is defaulted  to `EmptyView` here, i don't necessarily like this, but it is required and cleaner on the implementation side. This is true for any added enum that does not provide a `HeaderView` type.
public enum CalendarMonthHeaderView<HeaderView: View> {
    case custom((CalendarMonth) -> (HeaderView))
    case monthLabel(HeaderView = EmptyView())
    case monthYearLabel(HeaderView = EmptyView())
}
