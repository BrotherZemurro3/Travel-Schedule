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
            ZStack {
                HStack {
                    Button(action: {
                        navigationPath.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .frame(width: 17, height: 22)
                            .foregroundStyle(.blackDay)
                    }
                    Spacer()
                }
                Text("Выбор города")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            SearchBar(searchText: $searchCity)
                .padding(.bottom, 16)
            
            ScrollView {
                if filteredCities.isEmpty {
                    VStack {
                        Spacer()
                        Text("Город не найден")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blackDay)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 238)
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 200)
                } else {
                    LazyVStack {
                        ForEach(filteredCities) { city in
                            Button(action: {
                                selectedCity = city
                                navigationPath.append(ContentView.Destination.stations(city: city, isSelectingFrom: isSelectingFrom))
                            }) {
                                CityRowView(city: city)
                                    .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 4))
                                    .foregroundStyle(.blackDay)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
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
