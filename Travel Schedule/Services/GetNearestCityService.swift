//
//  GetNearestCityService.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 14.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCities(lat: Double, lng: Double)  async throws -> NearestCity
}


final class NearestCityService: NearestCityServiceProtocol {
  
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCities(lat: Double, lng: Double) async throws -> NearestCity {
        let response = try await client.getNearestCity(query: .init(apikey: apikey, lat: lat, lng: lng))
        
        return try response.ok.body.json
    }
    
}
