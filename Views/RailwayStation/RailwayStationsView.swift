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
            
            ScrollView {
                if filteredRailwayStations.isEmpty {
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
                        ForEach(filteredRailwayStations) { station in
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
                        .listStyle(.plain)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
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
