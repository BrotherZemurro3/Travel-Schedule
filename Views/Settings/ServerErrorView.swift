//
//  ServerErrorView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 30.07.2025.
//

import SwiftUI

struct ServerErrorView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Spacer()

            Image("ServerError")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .foregroundStyle(.grayUniversal)

            Text("Ошибка сервера")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDay)
                .padding(.top, 16)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            navigationPath.removeLast()
        }) {
            Image(systemName: "chevron.left")
                .foregroundStyle(.blackDay)
        })
    }
}

#Preview {
    ServerErrorView(navigationPath: .constant(NavigationPath()))
}
