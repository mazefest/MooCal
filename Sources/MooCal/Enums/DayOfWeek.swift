//
//  DayOfWeek.swift
//  CalyKitTestApp
//
//  Created by Colby Mehmen on 10/19/23.
//

import Foundation

public enum DayOfWeek: String, Identifiable {
    public var id: Self { return self }
    
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    public var title: String {
        return self.rawValue.capitalized
    }
    
    public var letter: String {
        return self.rawValue.first?.uppercased() ?? ""
    }
    
    /**
        - Returns: returns abbreviated forms of the days of week. ex: 3 characters for all days of the week (mon, tue).
     */
    public var abbreviated: String {
        switch self {
        default:
            return String(self.rawValue.capitalized.prefix(3))
        }
    }
    
    public var offSet: Int {
        // if start of week is monday, else it would be same sequence but start from sunday
        switch self {
        case .monday:
            return 0
        case .tuesday:
            return 1
        case .wednesday:
            return 2
        case .thursday:
            return 3
        case .friday:
            return 4
        case .saturday:
            return 5
        case .sunday:
            return 6
        }
    }
    
    public static var allCases: [Self] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }
    
    public static func allCasesStartingToday() -> [Self] {
        let today = DayOfWeek.create(from: Date())
        let startingIndex = Self.allCases.firstIndex(of: today)!
        let front: [DayOfWeek] = Array(allCases[0...startingIndex]).reversed() //m, t, w
        let back: [DayOfWeek] = Array(allCases[(startingIndex + 1)..<allCases.count]).reversed() // w,r,f,s,s]
        return (front + back)
    }
    
    public var endOfDay: Date {
        let index = Self.allCasesStartingToday().firstIndex(of: self)
        let today = Date()
        let indexedDate = Calendar.current.date(byAdding: .day, value: index! * -1, to: today)
        return indexedDate!.endOfDay
    }
    
    public var startOfDay: Date {
        let index = Self.allCasesStartingToday().firstIndex(of: self)
        
        let today = Date()
        let indexedDate = Calendar.current.date(byAdding: .day, value: index! * -1, to: today)
        return indexedDate!.startOfDay
    }
    
    public var dayNumber: String {
        return startOfDay.descriptor(.dayNumbered)
    }
    
    static public func create(from date: Date) -> Self {
        // Use numeric weekday component to avoid locale-dependent string matching.
        // Calendar.current.firstWeekday is typically 1 (Sunday) or 2 (Monday).
        // .weekday values: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        let weekday = Calendar.current.component(.weekday, from: date)
        switch weekday {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .sunday
        }
    }
}
