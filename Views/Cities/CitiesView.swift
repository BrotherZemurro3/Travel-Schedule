//
//  CitiesView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CitiesView: View {
    @State private var viewModel = CitiesViewModel()
    @Binding var selectedCity: Cities?
    @Binding var selectedStation: RailwayStations?
    @State private var searchCity = ""
    let isSelectingFrom: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        navigationPath.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .frame(width: 17, height: 26)
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
                .onChange(of: searchCity) { _, newValue in
                    viewModel.searchCities(query: newValue)
                }
            
            // Показываем индикатор загрузки
            if viewModel.isLoading {
                ProgressView("Загрузка городов...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text("Ошибка")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    if viewModel.filteredCities.isEmpty {
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
                            ForEach(viewModel.filteredCities) { city in
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
                        }
                    }
                }
            }
        }
                .task {
                    // Загружаем города при первом открытии экрана
                    await viewModel.loadAllCities()
                }
                .toolbar(.hidden, for: .tabBar)
                .navigationBarBackButtonHidden(true)
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
