//
//  Date+Ext.swift
//  Brush
//
//  Created by Colby Mehmen on 2/8/23.
//

import Foundation



// Date extensions, static functions
extension Date {
    /*
     @lhs -> the minuend
     @rhs -> the subtrahend
     @returns -> TimeInterval of the difference
     ex: if `lhs` is `Mar 3, 2023 at 11:45 PM` and `rhs` is `Mar 4, 2023 at 12:45 AM`
     a `TimeInterval` of `3600` will be returned
     **/
    static public func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    /*
     @date: -> date of the month where we will find the first date in.
     Static function that returns the first date of the
     month of the parameter date.
     ex: @Param:date = `Mar 3, 2023 at 10:22 PM`, the function will return `Mar 1, 2023 at 12:00 AM`
     **/
    static public func firstDateOfMonth(of date: Date) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: date))!
        return date
    }
    
    /*
     @date: -> date of the month where we will find the first date in.
     Static function that returns the last date of the
     month of the parameter date.
     ex: @Param:date = `Mar 3, 2023 at 10:22 PM`, the function will return `Mar 31, 2023 at 11:59 PM`
     **/
    static public func lastDateOfMonth(of date: Date) -> Date {
        let start = Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: date))!
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return  Calendar.current.date(byAdding: components, to: start)!
    }
}

// Date extensions that return a string
extension Date {
    /*
     A simple date formatter convenience enum
     `dayNumbered` -> `1`
     `dayOfWeek` -> `Monday`
     `month` -> `March`
     `year` => 2022
     **/
    public enum Descriptor {
        case dayNumbered
        case dayOfWeek
        case month
        case year
        
        public var dateFormatString: String {
            switch self {
            case .dayNumbered:
                return "dd"
            case .dayOfWeek:
                return "EEEE"
            case .month:
                return "MMMM"
            case .year:
                return "YYYY"
            }
        }
    }
    
    /*
     @descriptor -> the descriptor formate string to apply to the instance date
     ex: if date instance is `Mar 3, 2023 at 10:22 PM`
     `.dayNumbered` -> `3`
     `.dayOfWeek` -> `Friday`
     `.month` -> `March`
     `.year` -> `2023`
     **/
    public func descriptor(_ descriptor: Descriptor) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = descriptor.dateFormatString
        return dateFormatter.string(from: self)
    }

    public var timeFromNowFormatted: String {
        let minutesAgo = Int((Date() - self)/60)
        if minutesAgo < 60 {
            return "\(minutesAgo) m"
        } else if minutesAgo < (60 * 24) {
            return "\(Int(minutesAgo / 60)) h"
        } else {
            let days = Int(minutesAgo / (60 * 24))
            return "\(days) d"
        }
    }
}

// @returns -> Bool
extension Date {
    /*
     Returns a boolean comparing if the date the instance method is applied
     to is in the same month as the parameter date.
     **/
    public func inSameMonth(as date: Date) -> Bool {
        return self.isInRange(
            start: Self.firstDateOfMonth(of: date),
            end: Self.lastDateOfMonth(of: date)
        )
    }
    
    /*
     @returns -> boolean if instance is greater/equal than `beginningDate` and less/equal to `endDate`.
     @beginnigDate: Date -> will check if instance date is greater than or equal to
     @endDate: Date -> will check if instance date is greater than or equal to
     **/
    public func isInRange(start beginningDate: Date, end endDate: Date) -> Bool {
        return self >= beginningDate && self <= endDate
    }
    
    /*
     @returns -> boolean value if instance date is in the same day as paramater date
     @date -> the date to compare the instance date to
     **/
    public func isInDay(_ date: Date) -> Bool {
        return self.isInRange(start: date.startOfDay, end: date.endOfDay)
    }
    
    /*
     @hourOfDay -> the hour of day to comapare to instance date **military hour (1-24)
     @returns -> boolean value of if instance date hour is before `hourOfDay`
     NOTE: hour of Day works in milirart time, it adds `hourOfDay` to the start of the instance date.
     ex: will return true if instance is `Mar 3, 2023 at 3:45 PM` and `hourOfDay` is `18` where
     `18` represents `Mar 3, 2023 at 6:00 PM` of the current calendar.
     **/
    public func isBefore(hourOfDay: Int) -> Bool {
        let beforeDate = Calendar.current.date(byAdding: .hour, value: hourOfDay, to: self.startOfDay)
        return self < beforeDate!
    }
    
    /*
     @hourOfDay -> the hour of day to comapare to instance date **military hour (1-24)
     @returns -> boolean value of if instance date hour is after `hourOfDay`
     NOTE: hour of Day works in milirary time, it adds `hourOfDay` to the start of the instance date.
     ex: will return false if instance is `Mar 3, 2023 at 3:45 PM` and `hourOfDay` is `18` where
     `18` represents `Mar 3, 2023 at 6:00 PM` of the current calendar.
     **/
    public func isAfter(hourOfDay: Int) -> Bool {
        let afterDate = Calendar.current.date(byAdding: .hour, value: hourOfDay, to: self.startOfDay)
        return self > afterDate!
    }

    
    /*
     @beginningHour -> the hour of day to comapare if instance hour is greater than to instance date **military hour (1-24)
     @endHour -> the hour of day to comapare if instance hour is less than to instance date **military hour (1-24)
     Note: if date is `Mar 3, 2023 at 3:45 PM` and `beginningHour` is 3 and `endHour` is 4 it will return true
     **/
    public func isInBetween(beginningHour: Int, endHour: Int) -> Bool {
        return self.isAfter(hourOfDay: beginningHour) && self.isBefore(hourOfDay: endHour)
    }
    
    /*
     @returns -> boolean value if instance date is in the same day the day
     as the time the code is executed.
     @date -> the date to compare the instance date to
     **/
    public var isToday: Bool {
        let now = Date()
        return self.isInDay(now)
    }
}

// @returns -> Date
extension Date {
    /*
     Returns an array of Date Objects (starting at the beginning of the day) of every day
     in the month of the instance Date.
     ex: a date in february, returns a date for each day (28 Date objects starting at 12:00am).
     **/
    public func getAllDatesInMonth() -> [Date] {
        let calendar = Calendar.current
        let startOfMonth = Date.firstDateOfMonth(of: self)
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)! // This returns a Range<Int> for the month based off the start date.
        return range.compactMap { dayCount -> Date in
            return calendar.date(byAdding: .day, value: (dayCount - 1), to: startOfMonth)!
        } // returns an array of dates for given month, starting at midnight
    }
    
    /*
     @value -> Amount of calendar component to change by
     @component -> Calendary.Component [.day, month, year], to change by.
     @ returns a date object that is a result of adding the `value`
     of `components` to the instance date.
     **/
    public func changed(by value: Int, component: Calendar.Component) -> Date {
       return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    /*
     Returns a date object starting at 12:00am
     **/
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    /*
     Returns a date object starting at 11:59pm
     **/
    public var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(
            byAdding: components,
            to: Calendar.current.startOfDay(for: self)
        )!
    }

    /*
     This returns the calendar month `day offset`, this is the count of days befor the first
     day of the month in a calendar view.
     ex: if the first date of the month is on a a `Wednesday` -> `Mar 1, 2023 at 12:00 AM` then
     the off set will be `2` if the week starts on monday, and `3` if the week starts on
     sunday. 2 -> **WRFSS (**1,2,3,4,5) and 2 -> ***WRFS (***1,2,3,4). This is mainly used for
     drawing calendars
     **/
    public func monthStartOffset() -> Int {
        let date = Date.firstDateOfMonth(of: self)
        return DayOfWeek.create(from: date).offSet
    }
    
    /*
     this is the inverse of `monthStartOffset` find the last date of the month,
     and then returns the `inverse` of how many days are in the last week.
     ex: if the last date of the month is -> `Mar 31, 2023 at 11:59 PM` a `Friday`
     if the week begins on `monday` it will return `2` and if the week starts on
     sunday it will return a `1`. 2 -> MTWRF** (28,29,30,31,*, *) and 2 -> SMTWRFS* (27,28,29,30,31,*).
     This is mainly used for drawing calendars
     **/
    public func monthEndOffset() -> Int {
        let date = Date.lastDateOfMonth(of: self)
        let index = DayOfWeek.create(from: date).offSet
        return 6 - index
    }
    
    public func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!.startOfDay
    }
}


extension Date {
    public static func firstDateOfAllMonthsIn(start: Date, nextMonths: Int) -> [Date] {
        var monthDates: [Date] = [] // this is an array of dates starting at the first day of each month
        let todaysDateOfMonth = Date.firstDateOfMonth(of: start)
        
        for i in 0..<nextMonths {
            let monthDate = todaysDateOfMonth.changed(by: (i), component: .month)
            monthDates.append(monthDate)
        }

        return monthDates
    }
    
    public static func firstDateOfAllMonthsIn(start: Date, preMonths: Int, postMonths: Int) -> [Date] {
        var monthDates: [Date] = [] // this is an array of dates starting at the first day of each month
        let todaysDateOfMonth = Date.firstDateOfMonth(of: start)
        
        for i in 1..<preMonths{
            let monthDate = todaysDateOfMonth.changed(by: (i * -1), component: .month)
            monthDates.insert(monthDate, at: 0)
        }
        monthDates.append(todaysDateOfMonth)
        for i in 1..<postMonths{
            let monthDate = todaysDateOfMonth.changed(by: (i), component: .month)
            monthDates.append(monthDate)
        }

        return monthDates
    }
    
    func modified(by value: Int, component: Calendar.Component) -> Date {
        var dateComponent = DateComponents()
        switch component {
        case .day:
            dateComponent.day = value
        case .month:
            dateComponent.month = value
        case .weekOfYear, .weekOfMonth:
            dateComponent.weekOfYear = value
        case .year:
            dateComponent.year = value
        default:
            break
        }
        return Calendar.current.date(byAdding: dateComponent, to: self) ?? self
    }
}

