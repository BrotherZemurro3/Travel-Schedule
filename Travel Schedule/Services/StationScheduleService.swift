//
//  StationScheduleService.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 14.07.2025.
//


import OpenAPIRuntime
import OpenAPIURLSession

typealias StationSchedule = Components.Schemas.ScheduleResponse


protocol StationScheduleServiceProtocol {
    
    func getStationSchedule(station: String) async throws -> StationSchedule
}

final class StationScheduleService: StationScheduleServiceProtocol {
    
    private let client: Client
    
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(station: String) async throws -> StationSchedule {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            format: "json",
            transport_types: "suburban",
            direction: "на Москву",
            system: "yandex" // Явно указываем систему кодирования
        ))
        return try response.ok.body.json
    }
    
}
