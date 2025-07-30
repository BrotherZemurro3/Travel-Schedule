//
//  ScheduleView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import SwiftUI

struct ScheduleView: View {
    @State private var viewModel = StoriesViewModel()
    @State private var fromCity: Cities?
    @State private var fromStation: RailwayStations?
    @State private var toCity: Cities?
    @State private var toStation: RailwayStations?
    @State private var navigationPath = NavigationPath()
    @StateObject private var carrierViewModel = CarrierRouteViewModel()

    private var fromText: String {
        if let city = fromCity, let station = fromStation {
            return "\(city.cityName) (\(station.RailwayStationName))"
        } else if let city = fromCity {
            return city.cityName
        }
        return "Откуда"
    }

    private var toText: String {
        if let city = toCity, let station = toStation {
            return "\(city.cityName) (\(station.RailwayStationName))"
        } else if let city = toCity {
            return city.cityName
        }
        return "Куда"
    }

    private var isFindButtonEnabled: Bool {
        return fromStation != nil && toStation != nil
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 44) {
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .center, spacing: 12) {
                        ForEach(viewModel.story) { story in
                            StoriesCell(stories: story)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 140)
                .scrollIndicators(.hidden)

                VStack(spacing: 16) {
                    ZStack {
                        Color(UIColor(resource: .blueUniversal))
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Button(action: {
                                    navigationPath.append(Destination.cities(isSelectingFrom: true))
                                }) {
                                    Text(fromText)
                                        .foregroundStyle(fromCity == nil ? .grayUniversal : .blackUniversal)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                Button(action: {
                                    navigationPath.append(Destination.cities(isSelectingFrom: false))
                                }) {
                                    Text(toText)
                                        .foregroundStyle(toCity == nil ? .grayUniversal : .blackUniversal)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                            )
                            .padding(.horizontal, 16)

                            Button(action: {
                                let tempCity = fromCity
                                let tempStation = fromStation
                                fromCity = toCity
                                fromStation = toStation
                                toCity = tempCity
                                toStation = tempStation
                            }) {
                                Image("ChangeButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.blue)
                                    .padding(6)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 16)
                        }
                        .padding(.vertical, 16)
                    }
                    .frame(height: 128)
                    .padding(.horizontal, 16)

                    if isFindButtonEnabled {
                        Button(action: {
                            if let fromCity = fromCity, let fromStation = fromStation, let toCity = toCity, let toStation = toStation {
                                navigationPath.append(Destination.carriers(fromCity: fromCity, fromStation: fromStation, toCity: toCity, toStation: toStation))
                            }
                        }) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 150, height: 40)
                                .padding(.vertical, 12)
                                .background(Color(UIColor(resource: .blueUniversal)))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 16)
                    }
                }

                Spacer()

                Divider()
                    .frame(height: 3)
            }
            .padding(.top, 24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .cities(let isSelectingFrom):
                    CitiesView(
                        selectedCity: isSelectingFrom ? $fromCity : $toCity,
                        selectedStation: isSelectingFrom ? $fromStation : $toStation,
                        isSelectingFrom: isSelectingFrom,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .stations(let city, let isSelectingFrom):
                    RailwayStationsView(
                        selectedCity: city,
                        selectedStation: isSelectingFrom ? $fromStation : $toStation,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .carriers(let fromCity, let fromStation, let toCity, let toStation):
                    CarriersListView(
                        viewModel: carrierViewModel,
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .filters(let fromCity, let fromStation, let toCity, let toStation):
                    FiltersView(
                        viewModel: carrierViewModel,
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }

    enum Destination: Hashable {
        case cities(isSelectingFrom: Bool)
        case stations(city: Cities, isSelectingFrom: Bool)
        case carriers(fromCity: Cities, fromStation: RailwayStations, toCity: Cities, toStation: RailwayStations)
        case filters(fromCity: Cities, fromStation: RailwayStations, toCity: Cities, toStation: RailwayStations)
    }
}

#Preview {
    ScheduleView()
}
