//
//  CacheManager.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 18.09.2025.
//

import Foundation
import SwiftUI


@MainActor
final class CacheManager: ObservableObject {
    static let shared = CacheManager()
    
    // MARK: - Cache Storage
    @Published private var citiesCache: [Cities] = []
    @Published private var stationsCache: [String: [RailwayStations]] = [:]
    @Published private var scheduleCache: [String: [CarrierRoute]] = [:]
    
    // MARK: - Cache Timestamps
    private var citiesCacheTimestamp: Date?
    private var stationsCacheTimestamp: [String: Date] = [:]
    private var scheduleCacheTimestamp: [String: Date] = [:]
    
    // MARK: - Cache Settings
    private let cacheExpirationTime: TimeInterval = 30 * 60
    private let maxScheduleCacheSize = 50
    
    private init() {
        print("🗄️ CacheManager инициализирован")
    }
    
    // MARK: - Cities Cache
    
    
    func getCachedCities() -> [Cities]? {
        guard let timestamp = citiesCacheTimestamp,
              !isCacheExpired(timestamp: timestamp) else {
            print("🗄️ Кеш городов устарел или отсутствует")
            return nil
        }
        
        print("🗄️ Возвращаем кешированные города: \(citiesCache.count) шт.")
        return citiesCache
    }
    
    
    func cacheCities(_ cities: [Cities]) {
        citiesCache = cities
        citiesCacheTimestamp = Date()
        print("🗄️ Города сохранены в кеш: \(cities.count) шт.")
    }
    
    // MARK: - Stations Cache
    
    func getCachedStations(for cityName: String) -> [RailwayStations]? {
        guard let timestamp = stationsCacheTimestamp[cityName],
              !isCacheExpired(timestamp: timestamp),
              let stations = stationsCache[cityName] else {
            print("🗄️ Кеш станций для города '\(cityName)' устарел или отсутствует")
            return nil
        }
        
        print("🗄️ Возвращаем кешированные станции для '\(cityName)': \(stations.count) шт.")
        return stations
    }
    
    
    func cacheStations(_ stations: [RailwayStations], for cityName: String) {
        stationsCache[cityName] = stations
        stationsCacheTimestamp[cityName] = Date()
        print("🗄️ Станции для города '\(cityName)' сохранены в кеш: \(stations.count) шт.")
    }
    
    // MARK: - Schedule Cache
    
    
    func getCachedSchedule(from: String, to: String, date: String) -> [CarrierRoute]? {
        let key = "\(from)_\(to)_\(date)"
        
        guard let timestamp = scheduleCacheTimestamp[key],
              !isCacheExpired(timestamp: timestamp),
              let routes = scheduleCache[key] else {
            print("🗄️ Кеш расписания для '\(key)' устарел или отсутствует")
            return nil
        }
        
        print("🗄️ Возвращаем кешированное расписание для '\(key)': \(routes.count) шт.")
        return routes
    }
    
    
    func cacheSchedule(_ routes: [CarrierRoute], from: String, to: String, date: String) {
        let key = "\(from)_\(to)_\(date)"
        
        if scheduleCache.count >= maxScheduleCacheSize {
            clearOldestScheduleCache()
        }
        
        scheduleCache[key] = routes
        scheduleCacheTimestamp[key] = Date()
        print("🗄️ Расписание для '\(key)' сохранено в кеш: \(routes.count) шт.")
    }
    
    // MARK: - Cache Management
    
    
    private func isCacheExpired(timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) > cacheExpirationTime
    }
    
    
    private func clearOldestScheduleCache() {
        guard !scheduleCacheTimestamp.isEmpty else { return }
        
        
        let oldestKey = scheduleCacheTimestamp.min { $0.value < $1.value }?.key
        
        if let keyToRemove = oldestKey {
            scheduleCache.removeValue(forKey: keyToRemove)
            scheduleCacheTimestamp.removeValue(forKey: keyToRemove)
            print("🗄️ Удалена старая запись кеша расписания: \(keyToRemove)")
        }
    }
    
    
    func clearAllCache() {
        citiesCache.removeAll()
        stationsCache.removeAll()
        scheduleCache.removeAll()
        
        citiesCacheTimestamp = nil
        stationsCacheTimestamp.removeAll()
        scheduleCacheTimestamp.removeAll()
        
        print("🗄️ Весь кеш очищен")
    }
    
    func clearExpiredCache() {
        let now = Date()
        
        
        if let timestamp = citiesCacheTimestamp,
           now.timeIntervalSince(timestamp) > cacheExpirationTime {
            citiesCache.removeAll()
            citiesCacheTimestamp = nil
            print("🗄️ Устаревший кеш городов очищен")
        }
        
        
        for (cityName, timestamp) in stationsCacheTimestamp {
            if now.timeIntervalSince(timestamp) > cacheExpirationTime {
                stationsCache.removeValue(forKey: cityName)
                stationsCacheTimestamp.removeValue(forKey: cityName)
                print("🗄️ Устаревший кеш станций для '\(cityName)' очищен")
            }
        }
        
        
        for (key, timestamp) in scheduleCacheTimestamp {
            if now.timeIntervalSince(timestamp) > cacheExpirationTime {
                scheduleCache.removeValue(forKey: key)
                scheduleCacheTimestamp.removeValue(forKey: key)
                print("🗄️ Устаревший кеш расписания для '\(key)' очищен")
            }
        }
    }
    
}
