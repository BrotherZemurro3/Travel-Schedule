//
//  CarriersViewModel.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import Foundation
import SwiftUI
import Observation

struct CarrierRoute: Identifiable, Hashable {
    var id = UUID()
    var carrierName: String
    var date: String
    var departureTime: String
    var arrivalTime: String
    var duration: String
    var withTransfer: Bool
    var carrierImage: String
    var note: String?
}

class CarrierRouteViewModel: ObservableObject {
    @Published var routes: [CarrierRoute]
    @Published var selectedPeriods: Set<PeriodofTime> = []
    @Published var showWithTransfer: Bool? = nil // тут nil означает что фильтр пересадок не был применен
    
    init() {
        self.routes = [
            CarrierRoute(carrierName: "РЖД", date: "14 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: true, carrierImage: "RJDmock", note: "С пересадкой в Костроме"),
            CarrierRoute(carrierName: "ФГК", date: "15 января", departureTime: "01:15", arrivalTime: "09:00", duration: "9 часов", withTransfer: false, carrierImage: "FGKmock"),
            CarrierRoute(carrierName: "Урал логистика", date: "16 января", departureTime: "12:30", arrivalTime: "21:00", duration: "9 часов", withTransfer: false, carrierImage: "URALmock"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: true, carrierImage: "RJDmock", note: "С пересадкой в Костроме"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: false, carrierImage: "RJDmock"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: false, carrierImage: "RJDmock"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: false, carrierImage: "RJDmock")
        ]
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
                    isPeriodMatch = selectedPeriods.contains { period in
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

