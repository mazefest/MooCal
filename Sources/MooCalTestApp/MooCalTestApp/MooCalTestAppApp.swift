//
//  MooCalTestAppApp.swift
//  MooCalTestApp
//
//  Created by Colby Mehmen on 1/14/24.
//

import SwiftUI

@main
struct MooCalTestAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ContentView()
                }
                .tabItem {
                    Image(systemName: "1.circle.fill")
                }
                
                NavigationView {
                    ContentViewTwo()
                }
                .tabItem {
                    Image(systemName: "2.circle.fill")
                }
                
                NavigationView {
                    ContentViewThree()
                }
                .tabItem {
                    Image(systemName: "3.circle.fill")
                }
                
                NavigationView {
                    ContentViewFour()
                }
                .tabItem {
                    Image(systemName: "4.circle.fill")
                }
            }
            
        }
    }
}
