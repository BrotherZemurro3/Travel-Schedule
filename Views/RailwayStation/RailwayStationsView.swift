

import SwiftUI

struct RailwayStationsView: View {
    @State var viewModel = RailwayStationViewModel()
    @State private var searchStation = ""
    let selectedCity: Cities
    @Binding var selectedStation: RailwayStations?
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
                Text("Выбор станции")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            SearchBar(searchText: $searchStation)
                .padding(.bottom, 16)
                .onChange(of: searchStation) { _, newValue in
                    viewModel.searchStations(query: newValue)
                }
            
            // Показываем индикатор загрузки
            if viewModel.isLoading {
                ProgressView("Загрузка станций...")
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
                    if viewModel.filteredStations.isEmpty {
                        VStack {
                            Spacer()
                            Text("Станция не найдена")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.blackDay)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 238)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                        .padding(.bottom, 200)
                    } else {
                        LazyVStack{
                            ForEach(viewModel.filteredStations) { station in
                                Button(action: {
                                    selectedStation = station
                                    navigationPath.removeLast(navigationPath.count)
                                }) {
                                    RailwayStationRowView(railwayStation: station)
                                        .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
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
            // Загружаем станции для выбранного города
            await viewModel.loadStationsForCity(selectedCity)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
        RailwayStationsView(
            selectedCity: Cities(cityName: "Москва"),
            selectedStation: .constant(nil),
            navigationPath: .constant(NavigationPath())
        )
}

