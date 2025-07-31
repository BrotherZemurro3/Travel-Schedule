//
//  CityCell.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CityRowView: View {
    
    var city: Cities
    
    var body: some View {
        HStack {
            Text(city.cityName)
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
                    .foregroundStyle(.blackDay)
                    .padding(6)
            }
            .frame(maxHeight: .infinity)
            
        }
        
        .padding(.trailing, 8)
    }
}

