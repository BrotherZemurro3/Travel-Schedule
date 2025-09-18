//
//  TravelViewModel.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import Foundation
import SwiftUI
import Observation
import OpenAPIURLSession

/// Главный ViewModel для управления состоянием приложения
/// Использует @Observable для автоматического обновления UI
@Observable
class TravelViewModel {
    
    // MARK: - Navigation Properties
    /// Выбранная вкладка в TabView
    var selectedTab: Int = 0
    
    /// Путь навигации для NavigationStack
    var navigationPath = NavigationPath()
    
    // MARK: - Travel Data Properties
    /// Выбранный город отправления
    var fromCity: Cities?
    
    /// Выбранная станция отправления
    var fromStation: RailwayStations?
    
    /// Выбранный город назначения
    var toCity: Cities?
    
    /// Выбранная станция назначения
    var toStation: RailwayStations?
    
    // MARK: - API Data Properties
    /// Все доступные станции из API
    var allStations: [Station] = []
    
    /// Результаты поиска маршрутов
    var searchResults: [CarrierRoute] = []
    
    /// Состояние загрузки
    var isLoading: Bool = false
    
    /// Сообщение об ошибке
    var errorMessage: String?
    
    // MARK: - API Services
    private let getAllStationsService: GetAllStationsService
    private let scheduleService: SchedualBetweenStationsService
    private let nearestStationsService: NearestStationsService
    private let carrierInfoService: CarrierInfoService
    
    // MARK: - Initialization
    init() {
        // Инициализация API сервисов
        let client = Client(
            serverURL: URL(string: "https://api.rasp.yandex.net")!,
            transport: URLSessionTransport()
        )
        
        // ВАЖНО: Замените на ваш реальный API ключ от Яндекс.Расписаний
        let apiKey = "94795250-37d7-42dd-aa66-e6c2228ede23"
        
        self.getAllStationsService = GetAllStationsService(client: client, apikey: apiKey)
        self.scheduleService = SchedualBetweenStationsService(client: client, apikey: apiKey)
        self.nearestStationsService = NearestStationsService(client: client, apikey: apiKey)
        self.carrierInfoService = CarrierInfoService(client: client, apikey: apiKey)
    }
    
    // MARK: - Computed Properties
    
    /// Проверяет, можно ли выполнить поиск маршрутов
    var canSearch: Bool {
        return fromStation != nil && toStation != nil
    }
    
    /// Возвращает текст для поля "Откуда"
    var fromText: String {
        if let city = fromCity, let station = fromStation {
            return "\(city.cityName) (\(station.RailwayStationName))"
        } else if let city = fromCity {
            return city.cityName
        }
        return "Откуда"
    }
    
    /// Возвращает текст для поля "Куда"
    var toText: String {
        if let city = toCity, let station = toStation {
            return "\(city.cityName) (\(station.RailwayStationName))"
        } else if let city = toCity {
            return city.cityName
        }
        return "Куда"
    }
    
    // MARK: - Public Methods
    
    /// Обмен местами отправления и назначения
    func swapCities() {
        let tempCity = fromCity
        let tempStation = fromStation
        fromCity = toCity
        fromStation = toStation
        toCity = tempCity
        toStation = tempStation
    }
    
    /// Загрузка всех станций из API
    func loadAllStations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await getAllStationsService.getAllStations()
            await MainActor.run {
                self.allStations = self.processStationsResponse(response)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки станций: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// Поиск маршрутов между станциями
    func searchRoutes(from: String, to: String, date: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await scheduleService.getScheduleBetweenStations(from: from, to: to, date: date)
            await MainActor.run {
                self.searchResults = self.processRoutesResponse(response)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка поиска маршрутов: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// Очистка результатов поиска
    func clearSearchResults() {
        searchResults = []
        errorMessage = nil
    }
    
    /// Сброс выбранных городов и станций
    func resetSelection() {
        fromCity = nil
        fromStation = nil
        toCity = nil
        toStation = nil
        clearSearchResults()
    }
    
    // MARK: - Private Methods
    
    /// Обработка ответа API со списком станций
    private func processStationsResponse(_ response: AllStations) -> [Station] {
        // TODO: Реализовать преобразование данных из API в локальные модели
        // Это зависит от структуры ответа API
        return []
    }
    
    /// Обработка ответа API с результатами поиска маршрутов
    private func processRoutesResponse(_ response: SchedualBetweenStations) -> [CarrierRoute] {
        // TODO: Реализовать преобразование данных из API в локальные модели
        // Это зависит от структуры ответа API
        return []
    }
}

// MARK: - Supporting Models

/// Модель станции для работы с API
struct Station: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let title: String
    let shortTitle: String
    let popularTitle: String
    let lat: Double
    let lng: Double
    let transportType: String
}
