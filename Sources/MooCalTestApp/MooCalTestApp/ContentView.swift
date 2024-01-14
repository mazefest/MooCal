//
//  ContentView.swift
//  MooCalTestApp
//
//  Created by Colby Mehmen on 1/14/24.
//

import SwiftUI
import MooCal

struct ContentView: View {
    @State var events: [Event] = []
    @State var sheetState: SheetState? = nil
    
    var viewModel = ScrollableCalendarViewViewModel()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollableCalendarView(
                viewModel: viewModel,
                calendarDayView: .custom({ calendarDay in
                    customCalendarDayView(calendarDay)
                }),
                onSelection: { calendarDay in
                    let events = events.filter({$0.date.isInDay(calendarDay.date)}) // filter to events in calendar day
                    sheetState = .events(calendarDay, events)
                }
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
                    })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        sheetState = .eventInputSheet
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
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
    
    // Custom View
    private func customCalendarDayView(_ calendarDay: CalendarDay) -> some View {
        let events = events.filter({$0.date.isInDay(calendarDay.date)})
        
        return ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundStyle((calendarDay.date.isToday) ? Color.green.opacity(0.33) : Color.blue.opacity(0.13))
            Text(calendarDay.descriptor) // The day number. ex: 11
                .bold()
        }
        .aspectRatio(contentMode: .fit)
        .overlay {
            VStack {
                Spacer()
                HStack {
                    ForEach(events) { event in
                        Circle()
                            .foregroundStyle(.orange)
                            .frame(width: 5.0, height: 5.0)
                    }
                    Spacer()
                }
                .padding(6)
            }
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

#Preview {
    NavigationView {
        ContentView()
    }
}

