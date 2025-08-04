
import SwiftUI
import Foundation
import Observation



struct Cities: Identifiable, Hashable {
    var id = UUID()
    var cityName: String
}


class CitiesViewModel: ObservableObject {
    
    @Published var city: [Cities]
    
    
    init()  {
        self.city = [
            Cities(cityName: "Москва"),
            Cities(cityName: "Санкт-Петербург"),
            Cities(cityName: "Сочи"),
            Cities(cityName: "Горный воздух"),
            Cities(cityName: "Краснодар"),
            Cities(cityName: "Казань"),
            Cities(cityName: "Омск"),
        ]
    }
}




