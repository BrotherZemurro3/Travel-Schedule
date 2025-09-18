

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession


@globalActor
actor NetworkClient {
    static let shared = NetworkClient()
    
    private let client: Client
    private let apiKey: String
    
    private init() {
        self.client = Client(
            serverURL: URL(string: "https://api.rasp.yandex.net")!,
            transport: URLSessionTransport()
        )
        // ВАЖНО: Замените на ваш реальный API ключ от Яндекс.Расписаний
        self.apiKey = "94795250-37d7-42dd-aa66-e6c2228ede23"
    }
    
    // MARK: - Carrier Info Methods
    
   
    func getCarrierInfo(code: String) async throws -> Components.Schemas.CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(apikey: apiKey, code: code))
        return try response.ok.body.json
    }
    
    // MARK: - Copyright Methods
    

    func getCopyright(format: Operations.getCopyright.Input.Query.formatPayload = .json) async throws -> Components.Schemas.CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(
                apikey: apiKey,
                format: format
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Stations Methods
    
 
    func getAllStations() async throws -> Components.Schemas.AllStationsResponse {
        let response = try await client.getAllStations(query: .init(apikey: apiKey))
        
        let responseBody = try response.ok.body.html
        let limit = 50 * 1024 * 1024
        
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        return try JSONDecoder().decode(Components.Schemas.AllStationsResponse.self, from: fullData)
    }
    

    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> Components.Schemas.Stations {
        let response = try await client.getNearestStations(
            query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        return try response.ok.body.json
    }
    
 
    func getStationSchedule(
        station: String,
        format: String = "json",
        transportTypes: String = "suburban",
        direction: String = "на Москву",
        system: String = "yandex"
    ) async throws -> Components.Schemas.ScheduleResponse {
        let response = try await client.getStationSchedule(
            query: .init(
                apikey: apiKey,
                station: station,
                format: format,
                transport_types: transportTypes,
                direction: direction,
                system: system
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Route Methods
    

    func getRouteStations(uid: String) async throws -> Components.Schemas.Thread {
        let response = try await client.getThread(query: .init(apikey: apiKey, uid: uid))
        return try response.ok.body.json
    }
    

    func getScheduleBetweenStations(from: String, to: String, date: String) async throws -> Components.Schemas.Segments {
        let response = try await client.getSchedualBetweenStations(
            query: .init(
                apikey: apiKey,
                from: from,
                to: to,
                date: date
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Location Methods
    
   
    func getNearestCity(lat: Double, lng: Double) async throws -> Components.Schemas.NearestCityResponse {
        let response = try await client.getNearestCity(
            query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng
            )
        )
        return try response.ok.body.json
    }
}

// MARK: - Sendable Models


struct Station: Identifiable, Hashable, @unchecked Sendable {
    let id = UUID()
    let code: String
    let title: String
    let shortTitle: String
    let popularTitle: String
    let lat: Double
    let lng: Double
    let transportType: String
    let cityTitle: String?
    let regionTitle: String?
    
    init(
        code: String,
        title: String,
        shortTitle: String,
        popularTitle: String,
        lat: Double,
        lng: Double,
        transportType: String,
        cityTitle: String? = nil,
        regionTitle: String? = nil
    ) {
        self.code = code
        self.title = title
        self.shortTitle = shortTitle
        self.popularTitle = popularTitle
        self.lat = lat
        self.lng = lng
        self.transportType = transportType
        self.cityTitle = cityTitle
        self.regionTitle = regionTitle
    }
}


struct Route: Identifiable, @unchecked Sendable {
    let id = UUID()
    let from: String
    let to: String
    let departure: String
    let arrival: String
    let duration: String
    let carrier: String?
    let transportType: String
    let price: String?
    
    init(
        from: String,
        to: String,
        departure: String,
        arrival: String,
        duration: String,
        carrier: String? = nil,
        transportType: String,
        price: String? = nil
    ) {
        self.from = from
        self.to = to
        self.departure = departure
        self.arrival = arrival
        self.duration = duration
        self.carrier = carrier
        self.transportType = transportType
        self.price = price
    }
}

struct City: Identifiable, Hashable, @unchecked Sendable {
    let id = UUID()
    let title: String
    let regionTitle: String?
    let lat: Double?
    let lng: Double?
    
    init(
        title: String,
        regionTitle: String? = nil,
        lat: Double? = nil,
        lng: Double? = nil
    ) {
        self.title = title
        self.regionTitle = regionTitle
        self.lat = lat
        self.lng = lng
    }
}
