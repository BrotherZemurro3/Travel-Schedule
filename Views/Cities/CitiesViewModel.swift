
import SwiftUI
import Foundation
import Observation


struct Cities: Identifiable, Hashable, @unchecked Sendable {
    var id = UUID()
    var cityName: String
    var regionTitle: String?
    var lat: Double?
    var lng: Double?
    
    init(cityName: String, regionTitle: String? = nil, lat: Double? = nil, lng: Double? = nil) {
        self.cityName = cityName
        self.regionTitle = regionTitle
        self.lat = lat
        self.lng = lng
    }
}


@Observable
@MainActor
class CitiesViewModel {
    

    var cities: [Cities] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var searchText: String = ""
    
    // MARK: - Private Properties
    private let networkClient = NetworkClient.shared
    private let cacheManager = CacheManager.shared
    
    // MARK: - Computed Properties
    
    var filteredCities: [Cities] {
        if searchText.isEmpty {
            return cities
        }
        
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return cities.filter { city in
            let cityName = city.cityName.lowercased()
            let regionName = city.regionTitle?.lowercased() ?? ""
            
    
            if cityName.hasPrefix(trimmedSearch) {
                return true
            }
            
   
            if cityName.contains(trimmedSearch) {
                return true
            }
            
    
            if regionName.contains(trimmedSearch) {
                return true
            }
            
            return false
        }.sorted { city1, city2 in
            let city1Name = city1.cityName.lowercased()
            let city2Name = city2.cityName.lowercased()
            
      
            let city1StartsWithSearch = city1Name.hasPrefix(trimmedSearch)
            let city2StartsWithSearch = city2Name.hasPrefix(trimmedSearch)
            
            if city1StartsWithSearch && !city2StartsWithSearch {
                return true
            } else if !city1StartsWithSearch && city2StartsWithSearch {
                return false
            } else {
                return city1Name < city2Name
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
    }
    
    // MARK: - Public Methods
    
    func loadCitiesByLocation(lat: Double, lng: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getNearestCity(lat: lat, lng: lng)
            await MainActor.run {
                self.cities = self.processCitiesResponse(response)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки городов: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
  
    func loadAllCities() async {
        // Сначала проверяем кеш
        if let cachedCities = cacheManager.getCachedCities() {
            cities = cachedCities
            print("🗄️ Города загружены из кеша: \(cachedCities.count) шт.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getAllStations()
            await MainActor.run {
                let loadedCities = self.processAllStationsResponse(response)
                self.cities = loadedCities
                
                // Сохраняем в кеш
                self.cacheManager.cacheCities(loadedCities)
                
                self.isLoading = false
                print("🌍 Города загружены из API и сохранены в кеш: \(loadedCities.count) шт.")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки городов: \(error.localizedDescription)"
                // Используем моковые данные как fallback
                self.loadMockCities()
                self.isLoading = false
            }
        }
    }
    
  
    func searchCities(query: String) {
        searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        print("🔍 Поиск городов: '\(searchText)', всего городов: \(cities.count), найдено: \(filteredCities.count)")
    }
    

    func clearSearch() {
        searchText = ""
    }
    
    // MARK: - Private Methods
    
  
    private func loadMockCities() {
        cities = [
            Cities(cityName: "Москва", regionTitle: "Московская область", lat: 55.7558, lng: 37.6176),
            Cities(cityName: "Санкт-Петербург", regionTitle: "Ленинградская область", lat: 59.9311, lng: 30.3609),
            Cities(cityName: "Сочи", regionTitle: "Краснодарский край", lat: 43.5855, lng: 39.7231),
            Cities(cityName: "Горный воздух", regionTitle: "Сахалинская область", lat: 46.9628, lng: 142.7367),
            Cities(cityName: "Краснодар", regionTitle: "Краснодарский край", lat: 45.0448, lng: 38.9760),
            Cities(cityName: "Казань", regionTitle: "Республика Татарстан", lat: 55.8304, lng: 49.0661),
            Cities(cityName: "Омск", regionTitle: "Омская область", lat: 54.9885, lng: 73.3242),
        ]
    }
    

    private func processCitiesResponse(_ response: Components.Schemas.NearestCityResponse) -> [Cities] {

        return []
    }
    

    private func processAllStationsResponse(_ response: Components.Schemas.AllStationsResponse) -> [Cities] {
        guard let countries = response.countries else { return [] }
        
        var uniqueCities: [String: Cities] = [:]
        
        for country in countries {
        
            guard let countryTitle = country.title,
                  countryTitle.contains("Россия") || countryTitle.contains("Russia") || countryTitle.contains("РФ"),
                  let regions = country.regions else { continue }
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    guard let title = settlement.title,
                          let stations = settlement.stations else { continue }
                    
                 
                    let cityKey = title.lowercased()
                    
                    if uniqueCities[cityKey] == nil {
                   
                        let firstStation = stations.first
                        
                        uniqueCities[cityKey] = Cities(
                            cityName: title,
                            regionTitle: region.title,
                            lat: firstStation?.lat,
                            lng: firstStation?.lng
                        )
                    }
                }
            }
        }
        
   
        return Array(uniqueCities.values).sorted { $0.cityName < $1.cityName }
    }
}




