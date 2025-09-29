

import Foundation
import SwiftUI
import Observation


@Observable
@MainActor
class TravelViewModel {
    
    // MARK: - Navigation Properties
   
    var selectedTab: Int = 0
    var navigationPath = NavigationPath()
    
    // MARK: - Travel Data Properties

    var fromCity: Cities?
    var fromStation: RailwayStations?
    var toCity: Cities?
    var toStation: RailwayStations?
    
    // MARK: - API Data Properties
  
    var allStations: [Station] = []
    var searchResults: [Route] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var selectedDate: Date = Date()
    
    // MARK: - Private Properties
    private let networkClient = NetworkClient.shared
    
    // MARK: - Computed Properties
    
   
    var canSearch: Bool {
        return fromStation != nil && toStation != nil
    }
    
   
    var fromText: String {
        if let city = fromCity, let station = fromStation {
            return "\(city.cityName) (\(station.RailwayStationName))"
        } else if let city = fromCity {
            return city.cityName
        }
        return "Откуда"
    }
    
  
    var toText: String {
        if let city = toCity, let station = toStation {
            return "\(city.cityName) (\(station.RailwayStationName))"
        } else if let city = toCity {
            return city.cityName
        }
        return "Куда"
    }
    

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    // MARK: - Public Methods
    
  
    func swapCities() {
        let tempCity = fromCity
        let tempStation = fromStation
        fromCity = toCity
        fromStation = toStation
        toCity = tempCity
        toStation = tempStation
    }
    
  
    func loadAllStations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getAllStations()
            allStations = processStationsResponse(response)
            isLoading = false
        } catch {
            errorMessage = "Ошибка загрузки станций: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
   
    func searchRoutes() async {
        guard let fromCode = fromStation?.stationCode,
              let toCode = toStation?.stationCode else {
            errorMessage = "Выберите станции отправления и назначения"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getScheduleBetweenStations(
                from: fromCode,
                to: toCode,
                date: formattedDate
            )
            searchResults = processRoutesResponse(response)
            isLoading = false
        } catch {
            errorMessage = "Ошибка поиска маршрутов: \(error.localizedDescription)"
            isLoading = false
        }
    }
    

    func loadCarrierInfo(code: String) async -> Carrier? {
        do {
            let response = try await networkClient.getCarrierInfo(code: code)
            return processCarrierResponse(response)
        } catch {
            errorMessage = "Ошибка загрузки информации о перевозчике: \(error.localizedDescription)"
            return nil
        }
    }
    
  
    func clearSearchResults() {
        searchResults = []
        errorMessage = nil
    }
    
 
    func resetSelection() {
        fromCity = nil
        fromStation = nil
        toCity = nil
        toStation = nil
        clearSearchResults()
    }
    
   
    func setFromCity(_ city: Cities) {
        fromCity = city
        fromStation = nil // Сбрасываем станцию при смене города
    }
    
   
    func setFromStation(_ station: RailwayStations) {
        fromStation = station
    }
    
 
    func setToCity(_ city: Cities) {
        toCity = city
        toStation = nil // Сбрасываем станцию при смене города
    }
    
  
    func setToStation(_ station: RailwayStations) {
        toStation = station
    }
    

    func setSelectedDate(_ date: Date) {
        selectedDate = date
    }
    
    // MARK: - Private Methods
    
    private func processStationsResponse(_ response: Components.Schemas.AllStationsResponse) -> [Station] {
        return []
    }
    

    private func processRoutesResponse(_ response: Components.Schemas.Segments) -> [Route] {
        return []
    }
    
    private func processCarrierResponse(_ response: Components.Schemas.CarrierResponse) -> Carrier? {
        return nil
    }
}
