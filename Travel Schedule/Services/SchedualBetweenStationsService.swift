//
//  SchedualBetweenStationsService.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 14.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession


typealias SchedualBetweenStations = Components.Schemas.Segments


protocol SchedualBetweenStationsServiceProtocol {

    func getScheduleBetweenStations(from: String, to: String, date: String) async throws -> SchedualBetweenStations
}


final class SchedualBetweenStationsService: SchedualBetweenStationsServiceProtocol {
    
    
    private let client: Client
    
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String,to: String, date: String) async throws -> SchedualBetweenStations {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to, date: date))
        return try response.ok.body.json
        
    }
}
