//
//  CitiesView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CitiesView: View {
    @StateObject var viewModel = CitiesViewModel()
    @Binding var selectedCity: Cities?
    @Binding var selectedStation: RailwayStations?
    @State private var searchCity = ""
    let isSelectingFrom: Bool
    @Binding var navigationPath: NavigationPath

    private var filteredCities: [Cities] {
        searchCity.isEmpty ? viewModel.city : viewModel.city.filter { $0.cityName.lowercased().contains(searchCity.lowercased()) }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Выбор города")
                    .font(.system(size: 17, weight: .bold))
                
            }
            SearchBar(searchText: $searchCity)
            List(filteredCities) { city in
                Button(action: {
                    selectedCity = city
                    navigationPath.append(ScheduleView.Destination.stations(city: city, isSelectingFrom: isSelectingFrom))
                }) {
                    CityRowView(city: city)
                        .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 4))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                navigationPath.removeLast()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.blackDay)
            })
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    CitiesView(
        selectedCity: .constant(nil),
        selectedStation: .constant(nil),
        isSelectingFrom: true,
        navigationPath: .constant(NavigationPath())
    )
}
