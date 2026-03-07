

//
//  SwiftUIView.swift
//
//
//  Created by Colby Mehmen on 5/27/24.
//

import SwiftUI
import MooCal

struct ContentViewFour: View {
    @State var displayMode: WeatherDisplayMode = .icon
    @State var showingDisplaySelection: Bool = false
    
    var viewModel = ScrollableCalendarViewViewModel()

    var body: some View {
        ScrollableCalendarView(
            viewModel: viewModel,
            calendarDayView: .custom(
                { calendarDay in
                    customCalendarDayView(calendarDay)
                }
            )
        )
        .sheet(isPresented: $showingDisplaySelection, content: {
            displayModeSelectionSheet()
        })
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    showingDisplaySelection.toggle()
                }, label: {
                    self.displayMode.image
                        .padding(6)
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .foregroundStyle(Color.gray.opacity(0.33))
                        }
                })
            }
        })
    }
    
    private func displayModeSelectionSheet() -> some View {
        List {
            ForEach(WeatherDisplayMode.allCases) { displayMode in
                Label(
                    title: { Text(displayMode.name) },
                    icon: { displayMode.image }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    self.displayMode = displayMode
                    self.showingDisplaySelection = false
                }
            }
        }
    }
    
    // Custom Day View
    private func customCalendarDayView(_ calendarDay: CalendarDay) -> some View {
        return ZStack {
            VStack {
                Text(calendarDay.descriptor) // The day number. ex: 11
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
                    .opacity(0.33)
                
                calendarDayContentView()
                    .padding(.vertical, 1)
                

            }
            .padding(.bottom, 2)
        }
        .aspectRatio(contentMode: .fit)
    }
    
    @ViewBuilder
    private func calendarDayContentView() -> some View {
        switch self.displayMode {
            
        case .icon:
            WeatherTestAppUtil.randomWeatherType().image
                .font(.title2)
            
        case .temperature:
            let temp = WeatherTestAppUtil.randomTemperature()
            
            Text(WeatherTestAppUtil.tempFormattedString(temp: temp))
                .font(.title2)
                .foregroundStyle(Color.tempColor(value: temp))
                .bold()
                
        }
    }
}

// Util for mock data
class WeatherTestAppUtil {
    
    static func randomWeatherType() -> WeatherType {
        let allWeatherTypes: [WeatherType] = [.sun, .rain, .heavyRain, .cloudy, .thunderStorm, .snow, .cloudyAndSunny, .windy]
        return allWeatherTypes.randomElement()!
    }
    
    static func randomTemperature() -> Int {
        return Int.random(in: 20...99)
    }
    
    static func tempFormattedString(temp: Int) -> String {
        return "\(temp)°"
    }
}

// Convenience extension for temp color
extension Color {
    static func tempColor(value: Int) -> Color {
        if value < 40 {
            return .gray
        } else if value <= 75 {
            return .white
        } else if value <= 85 {
            return orange
        } else {
            return red
        }
    }
}

// Supported weather types
enum WeatherType {
    case sun
    case rain
    case heavyRain
    case cloudy
    case thunderStorm
    case snow
    case cloudyAndSunny
    case windy
    
    @ViewBuilder
    var image: some View {
        switch self {
        case .sun:
            Image(systemName: "sun.max.fill")
                .foregroundStyle(.orange)
                .bold()
            
        case .rain:
            Image(systemName: "cloud.drizzle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
            
        case .heavyRain:
            Image(systemName: "cloud.sun.rain.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .orange, .blue)
        case .cloudy:
            Image(systemName: "smoke.fill")
            
        case .thunderStorm:
            Image(systemName: "cloud.bolt.rain.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue, .blue)
            
        case .snow:
            Image(systemName: "snowflake")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray)
            
        case .cloudyAndSunny:
            Image(systemName: "cloud.sun.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .orange)
            
        case .windy:
            Image(systemName: "wind")
        }
    }
}

// Display Modes for calendar
enum WeatherDisplayMode: String, CaseIterable, Identifiable {
    var id: Self { return self }
    
    case icon
    case temperature
    
    var name: String {
        switch self {
        case .icon:
            return "Icons"
        case .temperature:
            return "Temperature"
        }
    }
    
    var image: Image {
        switch self {
        case .icon:
            Image(systemName: "sun.max.fill")
        case .temperature:
            Image(systemName: "thermometer.high")
        }
    }
}

#Preview {
    NavigationView {
        ContentViewFour()
    }
}
