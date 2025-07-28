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
}
