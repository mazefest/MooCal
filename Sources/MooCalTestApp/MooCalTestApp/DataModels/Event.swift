//
//  Event.swift
//  MooCalTestApp
//
//  Created by Colby Mehmen on 1/14/24.
//

import SwiftUI
import MooCal

public struct Event: ClassicCalendarData, CalendarData, Identifiable {
    public var id: UUID
    public var date: Date
    public var color: Color
    public var title: String
    public var creator: String
    
    public init(id: UUID = UUID(), date: Date, color: Color, title: String, creator: String) {
        self.id = id
        self.date = date
        self.color = color
        self.title = title
        self.creator = creator
    }
}
