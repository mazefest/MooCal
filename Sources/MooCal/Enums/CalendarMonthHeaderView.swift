//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 5/18/24.
//

import SwiftUI

// when using an enum without a `HeaderView` type (such as cusom), the compiler still needs to infer the `HeaderView` Type so that is why it is defaulted  to `EmptyView` here, i don't necessarily like this, but it is required and cleaner on the implementation side. This is true for any added enum that does not provide a `HeaderView` type.
public enum CalendarMonthHeaderView<HeaderView: View> {
    case custom((CalendarMonth) -> (HeaderView))
    case monthLabel(HeaderView = EmptyView())
    case monthYearLabel(HeaderView = EmptyView())
}
