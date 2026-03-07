//
//  ContentViewThree.swift
//  MooCalTestApp
//
//  Created by Colby Mehmen on 1/15/24.
//

import SwiftUI
import MooCal

struct ContentViewThree: View {
    @State var events: [Event] = []
    @State var sheetState: SheetState? = nil
    
    var viewModel = ScrollableCalendarViewViewModel()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollableCalendarView(
                viewModel: viewModel,
                calendarDayView: .custom(
                    { calendarDay in
                    customCalendarDayView(calendarDay)
                    }
                ),
                calendarDayOfWeekIndicatorView: .custom({ dayOfWeek in
                    customDayOfWeekIndicatorView(dayOfWeek: dayOfWeek)
                })
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        guard let currentMonthId = viewModel.currentMonthId else {
                            return
                        }
                        proxy.scrollTo(currentMonthId)
                    }, label: {
                        Text("Today")
                            .bold()
                    })
                    .tint(Color.blue)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        sheetState = .eventInputSheet
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tint(Color.blue)
                }
            }
            .sheet(item: $sheetState, content: { sheetState in
                switch self.sheetState {
                case .eventInputSheet, .none:
                    eventInputSheet()
                case .events(let calendarDay, let events):
                    calendarDayEventView(calendarDay: calendarDay, events: events)
                }
            })
        }
    }
    
    // Custom Day View
    private func customCalendarDayView(_ calendarDay: CalendarDay) -> some View {
        let events = events.filter({$0.date.isInDay(calendarDay.date)})
        let isToday = calendarDay.date.isToday
        
        return ZStack {
            Circle()
                .foregroundStyle((isToday) ? Color.green: Color.gray)
                .opacity(0.33)
            Text(calendarDay.descriptor) // The day number. ex: 11
                .font(.system(.body, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)
        }
        .aspectRatio(contentMode: .fit)
        .overlay {
            VStack {
                Spacer()
                HStack {
                    ForEach(events) { event in
                        Circle()
                            .foregroundStyle((isToday) ? .pink: .orange)
                            .frame(width: 5.0, height: 5.0)
                    }
                    Spacer()
                }
                .padding(6)
            }
        }
    }
    
    // Custom Day Of Week Indicator View
    private func customDayOfWeekIndicatorView(dayOfWeek: DayOfWeek) -> some View {
        ZStack {
            Text(dayOfWeek.abbreviated)
                .font(.system(.body, design: .rounded, weight: .semibold))
        }
    }

    
    // View for inputting event info
    private func eventInputSheet() -> some View {
        NavigationView {
            EventInputSheet { newEvent in
                self.events.append(newEvent)
            }
        }
        .navigationTitle("New Event")
    }
    
    // View for viewing, updating and modifying events
    private func calendarDayEventView(calendarDay: CalendarDay, events: [Event]) -> some View {
        NavigationView {
            DayEventView(events: events) { action in
                switch action {
                case .delete(let event):
                    guard let index = self.events.firstIndex(where: {$0.id == event.id}) else {
                        return
                    }
                    self.events.remove(at: index)
                    
                case .update(let event):
                    guard let index = self.events.firstIndex(where: {$0.id == event.id}) else {
                        return
                    }
                    self.events[index] = event
                }
            }
            .navigationTitle(calendarDay.date.formatted())
        }
    }
}

extension ContentViewThree {
    enum SheetState: Hashable, Identifiable {
        var id: Self { return self }
        case eventInputSheet
        case events(CalendarDay, [Event])
        
        var title: String {
            switch self {
            case .eventInputSheet:
                return "Event Input Sheet"
            case .events(_, _):
                return "Events"
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.title)
            
            switch self {
            case .events(_, let events):
                hasher.combine(events)
            default:
                break
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentViewThree()
    }
}
