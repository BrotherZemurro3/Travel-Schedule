//
//  CarriersListView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CarriersListView: View {
    @State private var carriersViewModel = CarriersViewModel()
    @Environment(CarrierRouteViewModel.self) private var routeViewModel
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
                    .padding(.leading, -1)
                if routeViewModel.isLoading {
                    ProgressView("Загрузка расписания...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else if let errorMessage = routeViewModel.errorMessage {
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
                } else if routeViewModel.filteredRoutes.isEmpty {
                    Spacer()
                    Text("Маршруты не найдены")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.blackDay)
                        .frame(width: 191, height: 29)
                        .padding(.bottom, 150)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(routeViewModel.filteredRoutes) { route in
                                Button(action: {
                                    // Навигация к экрану детальной информации о перевозчике
                                    print("Выбран маршрут: \(route.carrierName) в \(route.departureTime)")
                                    navigationPath.append(ContentView.Destination.carrierDetail(route: route))
                                }) {
                                    CarriersRowView(route: route)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 80) // Отступ для кнопки "Уточнить время"
                    }
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
                    navigationPath.append(ContentView.Destination.filters(
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation
                    ))
                }) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                    if !routeViewModel.selectedPeriods.isEmpty || routeViewModel.showWithTransfer != nil {
                        Circle()
                            .fill(.redUniversal)
                            .frame(width: 8, height: 8)
                            .padding(.leading, -4)
                    }
                }
                .frame(width: 343, height: 35)
                .padding(.vertical, 12)
                .background(Color(UIColor(resource: .blueUniversal)))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        
        .task {
            // Загружаем расписание между станциями
            print("🚉 Загрузка расписания:")
            print("   От: \(fromCity.cityName) - \(fromStation.RailwayStationName)")
            print("   Код станции отправления: \(fromStation.stationCode ?? "НЕТ КОДА")")
            print("   До: \(toCity.cityName) - \(toStation.RailwayStationName)")
            print("   Код станции прибытия: \(toStation.stationCode ?? "НЕТ КОДА")")
            
            let fromCode = fromStation.stationCode ?? ""
            let toCode = toStation.stationCode ?? ""
            
            if fromCode.isEmpty || toCode.isEmpty {
                print("❌ Отсутствуют коды станций - используем моковые данные")
                await routeViewModel.loadMockRoutes()
            } else {
                await routeViewModel.loadSchedule(
                    fromStation: fromCode,
                    toStation: toCode
                )
            }
        }
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
    // .environment(CarrierRouteViewModel())
}
