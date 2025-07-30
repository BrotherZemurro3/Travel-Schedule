//
//  FiltersView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//


import SwiftUI


enum PeriodofTime: String, CaseIterable, Hashable {
    case morning = "Утро 06:00 - 12:00"
    case day = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"
}

struct FiltersView: View {
    
    @ObservedObject var view: CarrierRouteViewModel
    let fromCity: String
    let fromStation: RailwayStations
    let toCity: Cities
    let toStation: RailwayStations
    @Binding var navigationPath: NavigationPath
    @State private var showWithTransfer: Bool?
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDay)
                .padding(.horizontal, 16)
            
            ForEach(PeriodofTime.allCases, id: \.self) { period in
                HStack {
                    Text(period.rawValue)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                    Spacer()

                }
            }
        }
    }
}

#Preview {
    FiltersView()
}
