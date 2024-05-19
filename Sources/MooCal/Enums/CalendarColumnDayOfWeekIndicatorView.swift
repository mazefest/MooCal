//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 5/18/24.
//

import SwiftUI

public enum CalendarColumnDayOfWeekIndicatorView<DayOfWeekIndicatorView: View> {
    case custom((DayOfWeek) -> (DayOfWeekIndicatorView))
    case singleLetter
    case abreviated
}
