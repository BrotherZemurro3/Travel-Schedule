//
//  RailwayStationRowView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import Foundation
import SwiftUI

struct RailwayStationRowView: View {
    
    var railwayStation: RailwayStations
    
    var body: some View {
        HStack {
            Text(railwayStation.RailwayStationName)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground).opacity(0.2))
                .cornerRadius(8)
            
            Spacer()
            
            
            Button(action: { print("Вставить переход позже") }) {
                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10.91, height: 18.82)
                    .foregroundStyle(.blackUniversal)
                    .padding(6)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.trailing, 8)
    }
}
