//
//  SwiftUIView.swift
//  
//
//  Created by Colby Mehmen on 1/13/24.
//

import SwiftUI

public struct ScrollableCalendarView<CustomView: View, HeaderView: View, DayOfWeekIndicatorView: View>: View {
    @ObservedObject var viewModel: ScrollableCalendarViewViewModel
    
    public var calendarHeaderView: CalendarMonthHeaderView<HeaderView>
    public var calendarDayView: CalendarDayView<CustomView>
    public var calendarDayOfWeekIndicatorView: CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView>
    public var onSelection: ((CalendarDay) -> ())?
    
    public init(viewModel: ScrollableCalendarViewViewModel = ScrollableCalendarViewViewModel(), calendarHeaderView: CalendarMonthHeaderView<HeaderView> = .monthLabel(), calendarDayView: CalendarDayView<CustomView>, calendarDayOfWeekIndicatorView: CalendarDayOfWeekIndicatorView<DayOfWeekIndicatorView> = .singleLetter(), onSelection: ( (CalendarDay) -> Void)? = nil) {
        self.viewModel = viewModel
        self.calendarHeaderView = calendarHeaderView
        self.calendarDayView = calendarDayView
        self.calendarDayOfWeekIndicatorView = calendarDayOfWeekIndicatorView
        self.onSelection = onSelection
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.addMonth(.toBeginning)
                    }, label: {
                        VStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundStyle(.secondary)
                                .bold()
                            Text("See More")
                                .foregroundStyle(.secondary)
                                .bold()
                        }
                    })
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .padding(.vertical, 20)
                
                CalendarMonthsView(
                    calendarMonths: viewModel.calendarMonths,
                    calendarHeaderView: calendarHeaderView,
                    calendarDayView: calendarDayView, 
                    calendarDayOfWeekIndicatorView: calendarDayOfWeekIndicatorView,
                    onSelection: onSelection
                )
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.addMonth(.toEnd)
                    }, label: {
                        VStack {
                            Text("See More")
                                .foregroundStyle(.secondary)
                                .bold()
                            
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundStyle(.secondary)
                                .bold()
                        }
                    })
                    .listRowBackground(Color.clear)
                    .buttonStyle(.plain)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
            .onAppear {
                guard let currentMonthId = viewModel.currentMonthId else { return }
                proxy.scrollTo(currentMonthId, anchor: .top)
            }
        }
    }
}

public class ScrollableCalendarViewViewModel: ObservableObject {
    @Published public var calendarMonths: [CalendarMonth]
    
    public var currentMonthId: UUID? {
        guard let currentCalendarMonth = calendarMonths.first(where: {$0.startDate.inSameMonth(as: Date())}) else { print("returning nil"); return nil }
        return currentCalendarMonth.id
    }
    
    public init(calendarMonths: [CalendarMonth]) {
        self.calendarMonths = calendarMonths
    }
    
    public init(currentDate: Date = Date(), preMonths: Int = 6, postMonths: Int = 6) {
        let dates = Date.firstDateOfAllMonthsIn(start: currentDate, preMonths: preMonths, postMonths: postMonths)
        self.calendarMonths = CalendarMonth.createCalendarMonths(fromMonthStartDates: dates, data: [])
    }
    
    public func addMonth(_ action: MonthAction) {
        guard let month = action.calendarMonthForIncrementing(calendarMonths: calendarMonths) else {
            return
        }
        let date = month.startDate
        let newDate = date.changed(by: action.incrementor, component: .month)
        let newMonth = CalendarMonth.createCalendarMonth(fromMonthStartDate: newDate, data: [])
        
        switch action {
        case .toBeginning:
            self.calendarMonths.insert(newMonth, at: 0)
        case .toEnd:
            self.calendarMonths.append(newMonth)
        }
    }
    
    public func addMonth(_ action: MonthAction, data: [CalendarData]) {
        guard let month = action.calendarMonthForIncrementing(calendarMonths: calendarMonths) else {
            return
        }
        let date = month.startDate
        let newDate = date.changed(by: action.incrementor, component: .month)
        let newMonth = CalendarMonth.createCalendarMonth(fromMonthStartDate: newDate, data: data)
        
        switch action {
        case .toBeginning:
            self.calendarMonths.insert(newMonth, at: 0)
        case .toEnd:
            self.calendarMonths.append(newMonth)
        }
    }
    
    public enum MonthAction {
        case toBeginning
        case toEnd
        
        var incrementor: Int {
            switch self {
            case .toBeginning:
                return -1
            case .toEnd:
                return 1
            }
        }
        
        public func calendarMonthForIncrementing(calendarMonths: [CalendarMonth]) -> CalendarMonth? {
            switch self {
            case .toBeginning:
                return calendarMonths.first
            case .toEnd:
                return calendarMonths.last
            }
        }
    }
}

