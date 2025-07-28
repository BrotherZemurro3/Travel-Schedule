//
//  StoriesCell.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import SwiftUI

struct StoriesCell: View {
    // Высота ячеек 140, ширина 92, радиус 16, бордер 4
    // Высота Коллекции такая же, ширина 404
    var stories: Stories
    let imageHeight: Double = 140
    let imageWidth: Double = 92
    var body: some View {
        VStack(alignment: .leading) {
            Image(stories.previewImage)
                .resizable()
                .cornerRadius(16)
                .frame(width: imageWidth, height: imageHeight)
                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.blue, lineWidth: 4)
                                )
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    StoriesCell(stories: Stories(previewImage: "ConductorGirlPreview", BigImage: "ConductorGirlBig"))
}
