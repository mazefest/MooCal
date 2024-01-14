//
//  CalendarMonthView.swift
//  CalyKitTestApp
//
//  Created by Colby Mehmen on 10/19/23.
//

import SwiftUI

//@available(iOS 16.0, *)
public struct CalendarMonthView<CustomView: View>: View {
    public var calendarMonth: CalendarMonth
    public var calendarDayView: CalendarDayView<CustomView>
    public var onSelection: ((CalendarDay) -> ())?
    
    public init(calendarMonth: CalendarMonth, calendarDayView: CalendarDayView<CustomView>, onSelection: ( (CalendarDay) -> Void)? = nil) {
        self.calendarMonth = calendarMonth
        self.calendarDayView = calendarDayView
        self.onSelection = onSelection
    }

    public var body: some View {
            VStack(spacing: 0.0) {
                title
                daysView
                    .padding()
            }
    }
    
    private var title: some View {
        Text(calendarMonth.title)
            .bold()
    }
    
    private var daysOfWeek: some View {
        ForEach(DayOfWeek.allCases) { day in
            Text("\(day.letter)")
        }
    }
    
    var trailingEmptyDayCount: Int {
        let d = (offSet + calendarMonth.days.count) % 7
        return 7 - d
    }
    
    public var offSet: Int {
        calendarMonth.startDate.monthStartOffset()
    }

    @ViewBuilder
    public var daysView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            daysOfWeek
            ForEach(0..<offSet) { i in
                RoundedRectangle(cornerRadius: 10.0)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.0))
            }
            
            // list all the days
            ForEach(calendarMonth.days) { i in
                Button {
                    onSelection?(i)
                } label: {
                    dayView(day: i)
                }
                .buttonStyle(.plain)
            }
            
            ForEach(0..<trailingEmptyDayCount) { i in
                Button(action: {
                    //
                }, label: {
                    RoundedRectangle(cornerRadius: 10.0)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray.opacity(0.0))
                })
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    public func dayView(day: CalendarDay) -> some View {
        switch calendarDayView {
        case .custom(let customView):
            customView(day)
            
        case .classic(let data):
            let filteredItems = data.filter({$0.date.isInDay(day.date)})
            ClassicCalendarDayView(day: day, items: filteredItems)
            
        case .numbered(let config):
            ClassicNumberedDayView(day: day, config: config)
        }
    }
    
//    @ViewBuilder
//    public func contributionDayView(calendarDay: CalendarDay, contributionType: ContributionType) -> some View {
//        switch contributionType {
//        case .count(let contributionConfig):
//            ContributionDayView(calendarDay: calendarDay, contributionConfig: contributionConfig)
//            
//        case .percent(let contributionPercentConfig):
//            completionGaugeView(calendarDay: calendarDay, contributionPercentConfig: contributionPercentConfig)
//        }
//    }
    
//    private func completionGaugeView(calendarDay: CalendarDay, contributionPercentConfig: ContributionPercentConfig) -> some View {
//        
//        print("max: \(contributionPercentConfig.value)")
//        print("\(calendarDay.date.formatted()) - \(calendarDay.sum)")
//        return CompletionGaugeView(color: contributionPercentConfig.color, min: 0, max: contributionPercentConfig.value, value: calendarDay.sum)
//            .background {
//                if calendarDay.date.isToday {
//                    Color.gray.opacity(0.35)
//                }
//            }
//    }
}
