//
//  ClassicCalendarDayView.swift
//  CalyKitTestApp
//
//  Created by Colby Mehmen on 10/22/23.
//

import SwiftUI

public struct ClassicNumberedDayViewConfig {
    public var textColor: Color
    public var backgroundColor: Color
    public var highlightToday: Bool
    public var highlightColor: Color
    public var cornerRadius: Double
    
    public init(textColor: Color = .white, backgroundColor: Color = .gray.opacity(0.33), highlightToday: Bool = true, highlightColor: Color = .blue, cornerRadius: Double = 10.0) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.highlightToday = highlightToday
        self.highlightColor = highlightColor
        self.cornerRadius = cornerRadius
    }

}

public struct ClassicNumberedDayView: View {
    public var day: CalendarDay
    public var config: ClassicNumberedDayViewConfig

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(config.backgroundColor)
            
            Text(day.descriptor)
                .font(.caption)
                .bold()
                .foregroundStyle(config.textColor)
        }
        .overlay {
            if config.highlightToday && day.date.isToday {
                RoundedRectangle(cornerRadius: config.cornerRadius)
                    .stroke(config.highlightColor, lineWidth: 3)
            }
        }
    }
}

@available(iOS 16.0, *)
public struct ClassicCalendarDayView/*<T: ClassicCalendarData & Identifiable>*/: View {
    public var day: CalendarDay
    public var items: [any ClassicCalendarData]
    
    public var body: some View {
        HStack(spacing: 0.0) {
            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundStyle(.clear)
                    .opacity(0.5)
                    .aspectRatio(contentMode: .fit)
                VStack(spacing: 0.0) {
                    HStack(spacing: 0.0) {
                        Spacer()
                        Text("\(day.date.descriptor(.dayNumbered))")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 4)
//
//                    ForEach(0..<items.count) { i in
//                            calendarListItem(item: items[i])
//                    }
                    ForEach(items, id: \.id) { item in
                        calendarListItem(item: item)
                    }

                    Spacer()
                    Divider()
                }
                
            }
            Divider()
        }
    }
    
    private func calendarListItem(item: any ClassicCalendarData) -> some View {
        HStack(spacing: 2.0) {
            Circle()
                .frame(width: 5.0, height: 5.0)
                .foregroundStyle(item.color)
            Text(item.title)
                .lineLimit(1)
                .foregroundStyle(.primary)
                .font(.custom("", size: 5))
            Spacer()
        }
        //.padding(.horizontal, 2)
    }
}

//#Preview {
//    let startOfMonth = Date().startOfMonth()
//    let dates = startOfMonth.getAllDatesInMonth()
//    let data = dates.compactMap({$0.getRandomEvent()})
//    let calendarDays = startOfMonth.getAllDatesInMonth().compactMap({
//        CalendarDay(date: $0, data: [])
//    })
//    
//    return CalendarMonthView(
//        calendarMonth: .init(startDate: startOfMonth, days: calendarDays)) { day in
//            let items = data.filter({$0.date.isInDay(day.date)})
//            
//            return ZStack {
//                Color.red
//                    .clipShape(Circle())
//                    .cornerRadius(10.0)
//                    .frame(width: 50.0, height: 50.0)
//                Text(day.descriptor)
//                    .foregroundStyle(.white)
//                    .bold()
//            }
//    } onSelection: { selectedDay in
//        //
//    }
//}

