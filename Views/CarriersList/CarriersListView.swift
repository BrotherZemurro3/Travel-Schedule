//
//  CarriersListView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CarriersListView: View {
    @StateObject var viewModel = CarrierRouteViewModel()
    let fromCity: Cities
    let fromStation: RailwayStations
    let toCity: Cities
    let toStation: RailwayStations
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("\(fromCity.cityName) (\(fromStation.RailwayStationName)) → \(toCity.cityName) (\(toStation.RailwayStationName))")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDay)
                .padding()
            List(viewModel.routes) { route in
                CarriersRowView(route: route)
                    .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .background(Color.clear)
        }
        
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

#Preview {
    CarriersListView(
        fromCity: Cities(cityName: "Москва"),
        fromStation: RailwayStations(RailwayStationName: "Киевский вокзал"),
        toCity: Cities(cityName: "Санкт-Петербург"),
        toStation: RailwayStations(RailwayStationName: "Московский вокзал"),
        navigationPath: .constant(NavigationPath())
    )
}
