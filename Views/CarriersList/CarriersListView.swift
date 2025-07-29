//
//  CarriersListView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CarriersListView: View {
    
    @State var viewModel = CarrierRouteViewModel()
    @State private var fromCity: Cities?
    @State private var fromStation: RailwayStations?
    @State private var toCity: Cities?
    @State private var toStation: RailwayStations?

    var body: some View {
        VStack {
            Text("\(fromCity) (\(fromStation)) → \(toCity)(\(toStation)")
                .font(.system(size: 24, weight: .bold))
            List(viewModel.routes) { route in
                CarriersRowView(route: route)
                    .listRowInsets(EdgeInsets(top: 4, leading: 9, bottom: 4, trailing: 8))
                    
            }
            .foregroundStyle(.whiteDay)
        }
        .foregroundStyle(.whiteDay)
    }
}

#Preview {
    CarriersListView()
}
