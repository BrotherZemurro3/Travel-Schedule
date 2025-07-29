//
//  RailwayStationsView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct RailwayStationsView: View {
    @StateObject var viewModel = RailwayStationViewModel()
    @State private var searchStation = ""
    let selectedCity: Cities
    @Binding var selectedStation: RailwayStations?
    @Binding var navigationPath: NavigationPath

    private var filteredRailwayStations: [RailwayStations] {
        searchStation.isEmpty ? viewModel.railwayStation : viewModel.railwayStation.filter {
            $0.RailwayStationName.lowercased().contains(searchStation.lowercased())
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Выбор станции")
                    .font(.system(size: 17, weight: .bold))
            }
            SearchBar(searchText: $searchStation)
            List(filteredRailwayStations) { station in
                Button(action: {
                    selectedStation = station
                    navigationPath.removeLast(navigationPath.count) // Clear navigation stack to return to ScheduleView
                }) {
                    RailwayStationRowView(railwayStation: station)
                        .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                navigationPath.removeLast()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.blue)
                Text("Назад")
                    .foregroundStyle(.blue)
            })
        }
    }
}

#Preview {
    RailwayStationsView(
        selectedCity: Cities(cityName: "Москва"),
        selectedStation: .constant(nil),
        navigationPath: .constant(NavigationPath())
    )
}
