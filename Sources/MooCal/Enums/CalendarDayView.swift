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
