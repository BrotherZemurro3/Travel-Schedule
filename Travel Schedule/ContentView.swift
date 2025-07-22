//
//  ContentView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 10.07.2025.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
   
        TabView(selection: $selectedTab) {

            ScheduleView()
            .tabItem {
                Label("", image: selectedTab == 0 ? "ScheduleActive" : "ScheduleInactive")
            }
            .tag(0)
            .edgesIgnoringSafeArea(.top)
            
            SettingsView()
            .tabItem {
                Label("", image: selectedTab == 1 ? "SettingsActive" : "SettingsInactive")
            }
            .tag(1)
            .edgesIgnoringSafeArea(.top)
        }
    }
    
}

#Preview {
    ContentView()
}
