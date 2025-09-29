

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation


typealias AllStations = Components.Schemas.AllStationsResponse


protocol AllStationsServiceProtocol {
    
    func getAllStations() async throws -> AllStations
}

final class GetAllStationsService {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStations {
       let response = try await client.getAllStations(query: .init(apikey: apikey))

        let responseBody = try response.ok.body.html
        
        let limit = 50 * 1024 * 1024

        var fullData = try await Data(collecting: responseBody, upTo: limit)

        let allStations = try JSONDecoder().decode(AllStations.self, from: fullData)
       return allStations
    }
    }

