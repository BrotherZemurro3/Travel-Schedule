//
//  CarriersViewModel.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 14.07.2025.
//

import Foundation
import SwiftUI
import Observation

struct Carrier: Identifiable, Hashable, @unchecked Sendable {
    let id = UUID()
    let code: String
    let title: String
    let phone: String?
    let email: String?
    let url: String?
}


@Observable
@MainActor
class CarriersViewModel {
    
    // MARK: - Published Properties
    var carriers: [Carrier] = []
    var selectedCarrier: Carrier?
    var isLoading: Bool = false
    var errorMessage: String?
    var searchText: String = ""
    
    // MARK: - Private Properties
    private let networkClient = NetworkClient.shared
    
    // MARK: - Computed Properties
    
    /// Отфильтрованные перевозчики по поисковому запросу
    var filteredCarriers: [Carrier] {
        if searchText.isEmpty {
            return carriers
        }
        return carriers.filter { carrier in
            carrier.title.localizedCaseInsensitiveContains(searchText) ||
            carrier.code.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        loadMockCarriers()
    }
    
    // MARK: - Public Methods
    
    
    func loadCarriers() async {
        isLoading = true
        errorMessage = nil
        

        await MainActor.run {
            self.loadMockCarriers()
            self.isLoading = false
        }
    }
    

    func loadCarrierInfo(code: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.getCarrierInfo(code: code)
            await MainActor.run {
                self.selectedCarrier = self.processCarrierResponse(response)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки информации о перевозчике: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    

    func searchCarriers(query: String) {
        searchText = query
    }
    
   
    func clearSearch() {
        searchText = ""
    }
    
    
    func selectCarrier(_ carrier: Carrier) {
        selectedCarrier = carrier
    }
    
    // MARK: - Private Methods
    
    private func loadMockCarriers() {
        carriers = [
            Carrier(
                code: "FGK",
                title: "ФГК (Федеральная грузовая компания)",
                phone: "+7 (800) 700-33-33",
                email: "info@fgk.ru",
                url: "https://www.fgk.ru"
            ),
            Carrier(
                code: "RJD",
                title: "РЖД (Российские железные дороги)",
                phone: "+7 (800) 775-00-00",
                email: "info@rzd.ru",
                url: "https://www.rzd.ru"
            ),
            Carrier(
                code: "URAL",
                title: "Уральские авиалинии",
                phone: "+7 (800) 770-02-02",
                email: "info@uralairlines.com",
                url: "https://www.uralairlines.com"
            )
        ]
    }
    
    private func processCarrierResponse(_ response: Components.Schemas.CarrierResponse) -> Carrier? {
        return nil
    }
}
