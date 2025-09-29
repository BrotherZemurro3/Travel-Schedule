

import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStations = Components.Schemas.Thread


protocol RouteStationsServiceProtocol {
    func getRouteStations(uid: String, format: String) async throws -> RouteStations
}

final class RouteStationsService: RouteStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String, format: String) async throws -> RouteStations {
        let response = try await client.getThread(query: .init(apikey: apikey, uid: uid))
        return try response.ok.body.json
    }
}
