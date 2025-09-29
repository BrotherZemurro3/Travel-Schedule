

import Foundation
import SwiftUI
import Observation
import OpenAPIRuntime
import OpenAPIURLSession

struct CarrierRoute: Identifiable, Hashable, @unchecked Sendable {
    var id = UUID()
    var carrierName: String
    var date: String
    var departureTime: String
    var arrivalTime: String
    var duration: String
    var withTransfer: Bool
    var carrierImage: String // Fallback изображение для локальных ресурсов
    var carrierLogoUrl: String? // URL логотипа перевозчика из API
    var note: String?
    var email: String
    var phone: String
}
@Observable
@MainActor
class CarrierRouteViewModel {
     var routes: [CarrierRoute]
     var selectedPeriods: Set<PeriodofTime> = []
     var showWithTransfer: Bool? = nil // тут nil означает что фильтр пересадок не был применен
     var isLoading: Bool = false
     var errorMessage: String?
     
     // MARK: - Private Properties
     private let networkClient = NetworkClient.shared
     private let cacheManager = CacheManager.shared
    
    init() {
        self.routes = []
        }
    
    // MARK: - Public Methods
    
    /// Загрузка расписания между станциями
    func loadSchedule(fromStation: String, toStation: String) async {
        print("🚂 Начинаем загрузку расписания:")
        print("   От станции: '\(fromStation)'")
        print("   До станции: '\(toStation)'")
        
        guard !fromStation.isEmpty && !toStation.isEmpty else {
            print("❌ Пустые коды станций!")
            await MainActor.run {
                self.errorMessage = "Не указаны станции отправления или прибытия"
            }
            return
        }
        
        // Используем текущую дату в формате YYYY-MM-DD
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        // Сначала проверяем кеш
        if let cachedRoutes = cacheManager.getCachedSchedule(from: fromStation, to: toStation, date: dateString) {
            routes = cachedRoutes
            print("🗄️ Расписание загружено из кеша: \(fromStation) -> \(toStation), маршрутов: \(cachedRoutes.count)")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("🗓️ Дата поиска: \(dateString)")
            print("🌐 Загружаем из API...")
            
            let response = try await networkClient.getScheduleBetweenStations(
                from: fromStation,
                to: toStation,
                date: dateString
            )
            
            print("✅ Получен ответ от API")
            
            await MainActor.run {
                let loadedRoutes = self.processScheduleResponse(response)
                self.routes = loadedRoutes
                
                // Сохраняем в кеш
                self.cacheManager.cacheSchedule(loadedRoutes, from: fromStation, to: toStation, date: dateString)
                
                self.isLoading = false
                print("🚂 Расписание загружено из API и сохранено в кеш: \(loadedRoutes.count) маршрутов")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки расписания: \(error.localizedDescription)"
                // Используем моковые данные как fallback
                self.loadMockRoutesSync()
                self.isLoading = false
                print("❌ Ошибка загрузки расписания: \(error.localizedDescription)")
                print("🔄 Используем моковые данные")
            }
        }
    }
    
    /// Загрузка моковых данных маршрутов (публичный метод)
    func loadMockRoutes() async {
        await MainActor.run {
            self.loadMockRoutesSync()
            self.isLoading = false
        }
    }
    
    // MARK: - Private Methods
    
    /// Загрузка моковых данных маршрутов (синхронный)
    private func loadMockRoutesSync() {
        routes = [
            CarrierRoute(
                carrierName: "РЖД",
                date: "14 января",
                departureTime: "22:30",
                arrivalTime: "08:15",
                duration: "20 часов",
                withTransfer: true,
                carrierImage: "RJDmock",
                carrierLogoUrl: "https://yastat.net/s3/rasp/media/data/company/logo/112.png",
                note: "С пересадкой в Костроме",
                email: "info@rzd.ru",
                phone: "+7 (800) 775-00-00"
            ),
            CarrierRoute(
                carrierName: "ФГК",
                date: "15 января",
                departureTime: "01:15",
                arrivalTime: "09:00",
                duration: "9 часов",
                withTransfer: false,
                carrierImage: "FGKmock",
                carrierLogoUrl: "https://yastat.net/s3/rasp/media/data/company/logo/996.png",
                email: "info@fgk.ru",
                phone: "+7 (495) 777-99-99"
            ),
            CarrierRoute(
                carrierName: "Урал логистика",
                date: "16 января",
                departureTime: "12:30",
                arrivalTime: "21:00",
                duration: "9 часов",
                withTransfer: false,
                carrierImage: "URALmock",
                carrierLogoUrl: "https://yastat.net/s3/rasp/media/data/company/logo/680.png",
                email: "info@ural-logistics.ru",
                phone: "+7 (343) 123-45-67"
            )
        ]
    }
    
    /// Обработка ответа API с расписанием
    private func processScheduleResponse(_ response: Components.Schemas.Segments) -> [CarrierRoute] {
        guard let segments = response.segments else { return [] }
        
        var scheduleRoutes: [CarrierRoute] = []
        
        for segment in segments {
            guard let thread = segment.thread,
                  let departure = segment.departure,
                  let arrival = segment.arrival else { continue }
            
            // Извлекаем информацию о маршруте
            let carrierName = thread.carrier?.title ?? "Неизвестный перевозчик"
            let threadTitle = thread.title ?? ""
            
            // Форматируем время
            let departureTime = formatTime(departure)
            let arrivalTime = formatTime(arrival)
            
            // Вычисляем продолжительность (упрощенно)
            let duration = calculateDuration(from: departure, to: arrival)
            
            // Определяем дату
            let date = formatDate(departure)
            
            // Определяем наличие пересадок (упрощенно - пока всегда false)
            let withTransfer = false // TODO: Определить по данным API
            
            // Определяем изображение перевозчика
            let carrierImage = getCarrierImage(for: carrierName)
            
            // Извлекаем URL логотипа из API
            let carrierLogoUrl = thread.carrier?.logo
            
            // Извлекаем контактную информацию из API
            let email = thread.carrier?.email ?? "Контактная информация не указана"
            let phone = thread.carrier?.phone ?? "Телефон не указан"
            
            let route = CarrierRoute(
                carrierName: carrierName,
                date: date,
                departureTime: departureTime,
                arrivalTime: arrivalTime,
                duration: duration,
                withTransfer: withTransfer,
                carrierImage: carrierImage,
                carrierLogoUrl: carrierLogoUrl,
                note: withTransfer ? "С пересадкой" : nil,
                email: email,
                phone: phone
            )
            
            scheduleRoutes.append(route)
        }
        
        return scheduleRoutes.sorted { $0.departureTime < $1.departureTime }
    }
    
    /// Форматирование времени из Date
    private func formatTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
    
    /// Форматирование даты из Date
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
    
    /// Вычисление продолжительности поездки
    private func calculateDuration(from departure: Date, to arrival: Date) -> String {
        let duration = arrival.timeIntervalSince(departure)
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours) ч \(minutes) мин"
        } else if hours > 0 {
            return "\(hours) ч"
        } else {
            return "\(minutes) мин"
        }
    }
    
    /// Получение изображения перевозчика
    private func getCarrierImage(for carrierName: String) -> String {
        let name = carrierName.lowercased()
        if name.contains("ржд") || name.contains("российские железные дороги") {
            return "RJDmock"
        } else if name.contains("фгк") || name.contains("федеральная грузовая") {
            return "FGKmock"
        } else if name.contains("урал") {
            return "URALmock"
        } else {
            return "RJDmock" // По умолчанию
        }
    }
        
        
        var filteredRoutes: [CarrierRoute] {
            let filtered = routes.filter { route in
                // Фильтрация по времени отправления
                let isPeriodMatch: Bool
                if selectedPeriods.isEmpty {
                    isPeriodMatch = true
                } else {
                    let departureTime = route.departureTime
                    let components = departureTime.split(separator: ":").compactMap { Int($0) }
                    guard let hour = components.first else {
                        print("Failed to parse departureTime: \(departureTime)")
                        return false
                    }
                    isPeriodMatch = selectedPeriods.contains { (period: Travel_Schedule.PeriodofTime) in
                        switch period {
                        case .morning: return hour >= 6 && hour < 12
                        case .day: return hour >= 12 && hour < 18
                        case .evening: return hour >= 18 && hour < 24
                        case .night: return (hour >= 0 && hour < 6) || hour == 24
                        }
                    }
                }
                
                // Фильтрация по пересадкам
                let isTransferMatch: Bool
                if let showWithTransfer = showWithTransfer {
                    isTransferMatch = route.withTransfer == showWithTransfer
                } else {
                    isTransferMatch = true
                }
                
                print("Route: \(route.departureTime), isPeriodMatch: \(isPeriodMatch), isTransferMatch: \(isTransferMatch)")
                return isPeriodMatch && isTransferMatch
            }
            print("Filtered routes count: \(filtered.count), selectedPeriods: \(selectedPeriods), showWithTransfer: \(String(describing: showWithTransfer))")
            return filtered
        }
    }

