//
//  CarriersListView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CarriersListView: View {
    @ObservedObject var viewModel: CarrierRouteViewModel
    let fromCity: Cities
    let fromStation: RailwayStations
    let toCity: Cities
    let toStation: RailwayStations
    @Binding var navigationPath: NavigationPath

    var body: some View {
        ZStack {
            VStack {
                Text("\(fromCity.cityName) (\(fromStation.RailwayStationName)) → \(toCity.cityName) (\(toStation.RailwayStationName))")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.blackDay)
                    .padding()
                if viewModel.filteredRoutes.isEmpty {
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.blackDay)
                        .frame(width: 171, height: 29)
                } else {
                    List(viewModel.filteredRoutes) { route in
                        CarriersRowView(route: route)
                            .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                navigationPath.removeLast()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.blackDay)
            })
            .toolbar(.hidden, for: .tabBar)

            VStack {
                Spacer()
                Button(action: {
                    navigationPath.append(ScheduleView.Destination.filters(
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation
                    ))
                }) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 343, height: 35)
                        .padding(.vertical, 12)
                        .background(Color(UIColor(resource: .blueUniversal)))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    CarriersListView(
        viewModel: CarrierRouteViewModel(),
        fromCity: Cities(cityName: "Москва"),
        fromStation: RailwayStations(RailwayStationName: "Киевский вокзал"),
        toCity: Cities(cityName: "Санкт-Петербург"),
        toStation: RailwayStations(RailwayStationName: "Московский вокзал"),
        navigationPath: .constant(NavigationPath())
    )
}
