//
//  CalendarDay.swift
//  CalyKitTestApp
//
//  Created by Colby Mehmen on 10/19/23.
//

import Foundation
import SwiftUI

public protocol ClassicCalendarData: Identifiable, Hashable {
    var id: UUID { get set }
    var date: Date { get set }
    var color: Color { get set }
    var title: String { get set }
}

public struct CalendarDay {
    public var id = UUID()
    public var date: Date
    public var data: [CalendarData]

    public init(id: UUID = UUID(), date: Date, data: [CalendarData]) {
        self.id = id
        self.date = date
        self.data = data
    }
    
    public var descriptor: String {
        return "\(date.descriptor(.dayNumbered))"
    }
}

extension CalendarDay: Identifiable {
    public static func == (lhs: CalendarDay, rhs: CalendarDay) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CalendarDay: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
