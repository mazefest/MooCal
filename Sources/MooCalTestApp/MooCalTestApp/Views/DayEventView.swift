//
//  DayEventView.swift
//  MooCalTestApp
//
//  Created by Colby Mehmen on 1/14/24.
//

import SwiftUI

struct DayEventView: View {
    @State var events: [Event]
    
    var onAction: (Action) -> ()
    
    enum Action {
        case delete(Event)
        case update(Event)
    }
    
    init(events: [Event], onAction: @escaping (Action) -> ()) {
        self._events = State(initialValue: events)
        self.onAction = onAction
    }
    
    var body: some View {
        List {
            ForEach(events) { event in
                NavigationLink {
                    EventInputSheet(event: event) { event in
                        update(event: event)
                    }
                } label: {
                    eventRowItemView(event: event)
                }
                .swipeActions {
                    Button(action: {
                        delete(event: event)
                    }, label: {
                        Image(systemName: "trash.fill")
                    })
                    .tint(Color.red)
                }
                
            }
        }
    }
    
    func eventRowItemView(event: Event) -> some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 10.0, height: 10.0)
                Text(event.title)
                Spacer()
            }
            HStack {
                Spacer()
                Text(event.date.formatted())
                    .font(.caption)
            }
        }
    }
    
    func delete(event: Event) {
        guard let index = events.firstIndex(of: event) else {
            return
        }
        self.events.remove(at: index)
        self.onAction(.delete(event))
    }
    
    func update(event: Event) {
        guard let index = events.firstIndex(where: {$0.id == event.id}) else {
            return
        }
        self.events[index] = event
        self.onAction(.update(event))
    }
}
