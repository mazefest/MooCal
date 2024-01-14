//
//  EventInputSheet.swift
//  MooCalTestApp
//
//  Created by Colby Mehmen on 1/14/24.
//

import SwiftUI
import MooCal

struct EventInputSheet: View {
    @Environment(\.dismiss) var dismiss
    
    private var id: UUID
    
    @State private var date: Date
    @State private var color: Color
    @State private var title: String
    @State private var creator: String
    
    var onSave: (Event) -> Void
    
    init(id: UUID = UUID(), date: Date = Date(), color: SwiftUI.Color = Color.blue, title: String = "", creator: String = "", onSave: @escaping (Event) -> Void) {
        self.id = id
        self._date = State(initialValue: date)
        self._color = State(initialValue: color)
        self._title = State(initialValue: title)
        self._creator = State(initialValue: creator)
        self.onSave = onSave
    }
    
    init(event: Event, onSave: @escaping (Event) -> Void) {
        self.init(
            id: event.id,
            date: event.date,
            color: event.color,
            title: event.title,
            creator: event.creator,
            onSave: onSave)
    }

    var body: some View {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                ColorPicker("Color", selection: $color)
                TextField("Title", text: $title)
                TextField("Creator", text: $creator)

                Button("Save") {
                    let event = Event(
                        id: id,
                        date: date,
                        color: color,
                        title: title,
                        creator: creator
                    )
                    
                    onSave(event)
                    dismiss()
                }
            }
            .navigationTitle("New Event")
    }
}
