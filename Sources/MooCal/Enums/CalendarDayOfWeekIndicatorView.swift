//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 5/18/24.
//

import SwiftUI

public enum CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView: View> {
    case custom((DayOfWeek) -> (DayOfWeekIndicatorView))
    case singleLetter(DayOfWeekIndicatorView = EmptyView())
    case abbreviated(DayOfWeekIndicatorView = EmptyView())
}
