//
//  CitiesView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CitiesView: View {
    @StateObject var viewModel = CitiesViewModel()
    @State private var searchCity = ""
    
    private var filteredCities: [Cities] {
        searchCity.isEmpty ? viewModel.city : viewModel.city.filter { $0.cityName.lowercased().contains(searchCity.lowercased())}
    }
    var body: some View {
        HStack{
            Text("Выбор города")
                .font(.system(size: 17, weight: .bold))
        }
        VStack{
            SearchBar(searchText: $searchCity)
            List(filteredCities) { city in
                CityRowView(city: city)
                    .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
        }
    }
}



#Preview {
    CitiesView()
}
