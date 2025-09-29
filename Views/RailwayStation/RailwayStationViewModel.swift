

import SwiftUI
import Foundation
import Observation
import OpenAPIRuntime
import OpenAPIURLSession

struct RailwayStations: Identifiable, Hashable, @unchecked Sendable {
    var id = UUID()
    var RailwayStationName: String
    var stationCode: String?
    var cityTitle: String?
    var regionTitle: String?
    var lat: Double?
    var lng: Double?
    var transportType: String?
    
    init(
        RailwayStationName: String,
        stationCode: String? = nil,
        cityTitle: String? = nil,
        regionTitle: String? = nil,
        lat: Double? = nil,
        lng: Double? = nil,
        transportType: String? = nil
    ) {
        self.RailwayStationName = RailwayStationName
        self.stationCode = stationCode
        self.cityTitle = cityTitle
        self.regionTitle = regionTitle
        self.lat = lat
        self.lng = lng
        self.transportType = transportType
    }
}


@Observable
@MainActor
class RailwayStationViewModel {
    
    // MARK: - Published Properties
    var railwayStations: [RailwayStations] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var searchText: String = ""
    
    // MARK: - Private Properties
    private let networkClient = NetworkClient.shared
    private let cacheManager = CacheManager.shared
    
    // MARK: - Computed Properties
    

    var filteredStations: [RailwayStations] {
        if searchText.isEmpty {
            return railwayStations
        }
        return railwayStations.filter { station in
            station.RailwayStationName.localizedCaseInsensitiveContains(searchText) ||
            station.cityTitle?.localizedCaseInsensitiveContains(searchText) == true ||
            station.regionTitle?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
 
    func loadAllStations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getAllStations()
            await MainActor.run {
                self.railwayStations = self.processStationsResponse(response)
                self.isLoading = false
                print("🚉 Загружено станций: \(self.railwayStations.count)")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки станций: \(error.localizedDescription)"
                // Используем моковые данные как fallback
                self.loadMockStations()
                self.isLoading = false
                print("❌ Ошибка загрузки станций: \(error.localizedDescription)")
            }
        }
    }
    
   
    func loadStationsForCity(_ city: Cities) async {
        // Сначала проверяем кеш
        if let cachedStations = cacheManager.getCachedStations(for: city.cityName) {
            railwayStations = cachedStations
            print("🗄️ Станции для города '\(city.cityName)' загружены из кеша: \(cachedStations.count) шт.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getAllStations()
            await MainActor.run {
                let loadedStations = self.processStationsResponseForCity(response, cityName: city.cityName)
                self.railwayStations = loadedStations
                
                // Сохраняем в кеш
                self.cacheManager.cacheStations(loadedStations, for: city.cityName)
                
                self.isLoading = false
                print("🚉 Станции для города '\(city.cityName)' загружены из API и сохранены в кеш: \(loadedStations.count) шт.")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки станций для города \(city.cityName): \(error.localizedDescription)"
                self.isLoading = false
                print("❌ Ошибка загрузки станций для города \(city.cityName): \(error.localizedDescription)")
            }
        }
    }
    
   
    func loadNearestStations(lat: Double, lng: Double, distance: Int = 50) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getNearestStations(lat: lat, lng: lng, distance: distance)
            await MainActor.run {
                self.railwayStations = self.processNearestStationsResponse(response)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки ближайших станций: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    

    func searchStations(query: String) {
        searchText = query
    }
    
  
    func clearSearch() {
        searchText = ""
    }
    
    // MARK: - Private Methods
    
    /// Загрузка моковых данных станций
    private func loadMockStations() {
        railwayStations = [
            RailwayStations(
                RailwayStationName: "Киевский вокзал",
                stationCode: "s9600213",
                cityTitle: "Москва",
                regionTitle: "Московская область",
                lat: 55.7447,
                lng: 37.5658,
                transportType: "train"
            ),
            RailwayStations(
                RailwayStationName: "Курский вокзал",
                stationCode: "s9600066",
                cityTitle: "Москва",
                regionTitle: "Московская область",
                lat: 55.7565,
                lng: 37.6617,
                transportType: "train"
            ),
            RailwayStations(
                RailwayStationName: "Ярославский вокзал",
                stationCode: "s9600215",
                cityTitle: "Москва",
                regionTitle: "Московская область",
                lat: 55.7764,
                lng: 37.6577,
                transportType: "train"
            ),
            RailwayStations(
                RailwayStationName: "Белорусский вокзал",
                stationCode: "s9600212",
                cityTitle: "Москва",
                regionTitle: "Московская область",
                lat: 55.7764,
                lng: 37.5821,
                transportType: "train"
            ),
            RailwayStations(
                RailwayStationName: "Савеловский вокзал",
                stationCode: "s9600214",
                cityTitle: "Москва",
                regionTitle: "Московская область",
                lat: 55.7936,
                lng: 37.5876,
                transportType: "train"
            ),
            RailwayStations(
                RailwayStationName: "Ленинградский вокзал",
                stationCode: "s9600216",
                cityTitle: "Москва",
                regionTitle: "Московская область",
                lat: 55.7764,
                lng: 37.6549,
                transportType: "train"
            )
        ]
    }
    
  
    private func processStationsResponse(_ response: Components.Schemas.AllStationsResponse) -> [RailwayStations] {
        guard let countries = response.countries else { return [] }
        
        var allStations: [RailwayStations] = []
        
        for country in countries {
            // Фильтруем только станции России
            guard let countryTitle = country.title,
                  countryTitle.contains("Россия") || countryTitle.contains("Russia") || countryTitle.contains("РФ"),
                  let regions = country.regions else { continue }
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    guard let cityTitle = settlement.title,
                          let stations = settlement.stations else { continue }
                    
                    for station in stations {
                        guard let stationTitle = station.title else { continue }
                        
                        // Пробуем получить код станции из разных источников
                        let stationCode = station.code ?? station.codes?.yandex_code
                        
                        print("🚉 Станция: \(stationTitle)")
                        print("   Код: \(stationCode ?? "НЕТ КОДА")")
                        print("   Город: \(cityTitle)")
                        
                        let railwayStation = RailwayStations(
                            RailwayStationName: stationTitle,
                            stationCode: stationCode,
                            cityTitle: cityTitle,
                            regionTitle: region.title,
                            lat: station.lat,
                            lng: station.lng,
                            transportType: station.transport_type
                        )
                        allStations.append(railwayStation)
                    }
                }
            }
        }
        
        return allStations.sorted { $0.RailwayStationName < $1.RailwayStationName }
    }
    

    private func processStationsResponseForCity(_ response: Components.Schemas.AllStationsResponse, cityName: String) -> [RailwayStations] {
        guard let countries = response.countries else { return [] }
        
        var cityStations: [RailwayStations] = []
        
        for country in countries {
            guard let countryTitle = country.title,
                  countryTitle.contains("Россия") || countryTitle.contains("Russia") || countryTitle.contains("РФ"),
                  let regions = country.regions else { continue }
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    guard let settlementTitle = settlement.title,
                          settlementTitle.lowercased() == cityName.lowercased(),
                          let stations = settlement.stations else { continue }
                    
                    for station in stations {
                        guard let stationTitle = station.title else { continue }
                        
                        // Пробуем получить код станции из разных источников
                        let stationCode = station.code ?? station.codes?.yandex_code
                        
                        print("🚉 Станция города \(cityName): \(stationTitle)")
                        print("   Код: \(stationCode ?? "НЕТ КОДА")")
                        
                        let railwayStation = RailwayStations(
                            RailwayStationName: stationTitle,
                            stationCode: stationCode,
                            cityTitle: settlementTitle,
                            regionTitle: region.title,
                            lat: station.lat,
                            lng: station.lng,
                            transportType: station.transport_type
                        )
                        cityStations.append(railwayStation)
                    }
                }
            }
        }
        
        return cityStations.sorted { $0.RailwayStationName < $1.RailwayStationName }
    }
    
  
    private func processNearestStationsResponse(_ response: Components.Schemas.Stations) -> [RailwayStations] {
        guard let stations = response.stations else { return [] }
        
        var nearestStations: [RailwayStations] = []
        
        for station in stations {
            guard let title = station.title else { continue }
            
            let railwayStation = RailwayStations(
                RailwayStationName: title,
                stationCode: station.code,
                cityTitle: nil, 
                regionTitle: nil,
                lat: station.lat,
                lng: station.lng,
                transportType: station.transport_type
            )
            nearestStations.append(railwayStation)
        }
        
        return nearestStations.sorted { $0.RailwayStationName < $1.RailwayStationName }
    }
}
