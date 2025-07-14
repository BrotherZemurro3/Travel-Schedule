import OpenAPIRuntime
import OpenAPIURLSession

typealias Copyright = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright(format: Operations.getCopyright.Input.Query.formatPayload) async throws -> Copyright
}

final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCopyright(format: Operations.getCopyright.Input.Query.formatPayload = .json) async throws -> Copyright {
        let response = try await client.getCopyright(
            query: .init(
                apikey: apikey,
                format: format  // Передаем значение `format`, а не тип `String`
            )
        )
        return try response.ok.body.json
    }
}
