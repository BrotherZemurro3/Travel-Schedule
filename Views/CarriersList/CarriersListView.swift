//
//  CarriersListView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CarriersListView: View {
    
    @State var viewModel = CarrierRouteViewModel()
    var body: some View {
        VStack {
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
