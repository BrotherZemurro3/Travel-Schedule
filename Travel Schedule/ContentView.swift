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
        ZStack(alignment: .top) {
            TabView(selection: $selectedTab) {
                ScheduleView()
                    .tabItem {
                        Label("", image: selectedTab == 0 ? "ScheduleActive" : "ScheduleInactive")
                    }
                    .tag(0)
                SettingsView()
                    .tabItem {
                        Label("", image: selectedTab == 1 ? "SettingsActive" : "SettingsInactive")
                    }
                    .tag(1)
                
            }
            .overlay(Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.3))
                .offset(y: -49),
                     alignment: .bottom)
            }
        }
    }
    


#Preview {
    ContentView()
}
