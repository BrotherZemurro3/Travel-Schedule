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
    
    private var filteredRailwayStations: [RailwayStations] {
        searchStation.isEmpty ? viewModel.railwayStation : viewModel.railwayStation.filter {
            $0.RailwayStationName.lowercased().contains(searchStation.lowercased())
        }
    }
    var body: some View {
        HStack {
            Text("Выбор станции")
                .font(.system(size: 17, weight: .bold))
        }
        VStack{
            SearchBar(searchText: $searchStation)
            List(filteredRailwayStations) { station in
                RailwayStationRowView(railwayStation: station)
                    .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    RailwayStationsView()
}
