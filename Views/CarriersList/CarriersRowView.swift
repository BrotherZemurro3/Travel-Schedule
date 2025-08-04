//
//  CarriersRowView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct CarriersRowView: View {
    
    var route: CarrierRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Image(route.carrierImage)
                    .resizable()
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 2) {
                    Text(route.carrierName)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                    route.note != nil ? Text(route.note!)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.redUniversal) : nil
                }
                Spacer()
                    Text(route.date)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.redUniversal)
                }
                
                .padding(.bottom, 5)
                
                HStack {
                    Text(route.departureTime)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.grayUniversal)
                    Text(route.duration)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.grayUniversal)
                    Text(route.arrivalTime)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                    
                }
                
            }
            .padding()
            .background(.lightGray)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
#Preview {
    CarriersRowView(route:  CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: true, carrierImage: "RJDmock", note: "С пересадкой в Костроме"))
}
