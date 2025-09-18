//
//  ContentView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 10.07.2025.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    // MARK: - ViewModels
    @State private var travelViewModel = TravelViewModel()
    @State private var settingsViewModel = SettingsViewModel()
    @State private var carrierViewModel = CarrierRouteViewModel()

    var body: some View {
        NavigationStack(path: $travelViewModel.navigationPath) {
            ZStack(alignment: .top) {
                TabView(selection: $travelViewModel.selectedTab) {
                    ScheduleView()
                        .environment(travelViewModel)
                        .environment(carrierViewModel)
                        .tabItem {
                            Label("", image: travelViewModel.selectedTab == 0 ? "ScheduleActive" : "ScheduleInactive")
                        }
                        .tag(0)
                    
                    SettingsView()
                        .environment(settingsViewModel)
                        .tabItem {
                            Label("", image: travelViewModel.selectedTab == 1 ? "SettingsActive" : "SettingsInactive")
                        }
                        .tag(1)
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black.opacity(0.3))
                        .offset(y: -49),
                    alignment: .bottom
                )
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .cities(let isSelectingFrom):
                    CitiesView(
                        selectedCity: isSelectingFrom ? $travelViewModel.fromCity : $travelViewModel.toCity,
                        selectedStation: isSelectingFrom ? $travelViewModel.fromStation : $travelViewModel.toStation,
                        isSelectingFrom: isSelectingFrom,
                        navigationPath: $travelViewModel.navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .stations(let city, let isSelectingFrom):
                    RailwayStationsView(
                        selectedCity: city,
                        selectedStation: isSelectingFrom ? $travelViewModel.fromStation : $travelViewModel.toStation,
                        navigationPath: $travelViewModel.navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .carriers(let fromCity, let fromStation, let toCity, let toStation):
                    CarriersListView(
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $travelViewModel.navigationPath
                    )
                    .environment(carrierViewModel)
                    .toolbar(.hidden, for: .tabBar)
                case .filters(let fromCity, let fromStation, let toCity, let toStation):
                    FiltersView(
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $travelViewModel.navigationPath
                    )
                    .environment(carrierViewModel)
                case .carrierDetail(let route):
                    CarrierDetailView(route: route, navigationPath: $travelViewModel.navigationPath)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .preferredColorScheme(settingsViewModel.colorScheme)
    }

    enum Destination: Hashable {
        case cities(isSelectingFrom: Bool)
        case stations(city: Cities, isSelectingFrom: Bool)
        case carriers(fromCity: Cities, fromStation: RailwayStations, toCity: Cities, toStation: RailwayStations)
        case filters(fromCity: Cities, fromStation: RailwayStations, toCity: Cities, toStation: RailwayStations)
        case carrierDetail(route: CarrierRoute)
    }
}

#Preview {
    ContentView()
}
