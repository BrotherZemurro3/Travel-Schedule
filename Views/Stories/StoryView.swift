//
//  StoryView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 06.08.2025.
//

import SwiftUI
import Combine

struct StoryView: View {
    var viewModel: StoriesViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            Color.blackUniversal.edgesIgnoringSafeArea(.all)
            Image(viewModel.story[viewModel.currentStoryIndex].images[viewModel.currentImageIndex])
                .resizable()
                .scaledToFit()
                .cornerRadius(40)
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                    
                Text("Text,Text,Text,Text,Text,Text,Text,Text, Text,Text,Text,Text,Text,Text,Text,Text,")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text("Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text")
                
                    .font(.system(size: 20, weight: .regular))
                    .lineLimit(3)
                    .foregroundColor(.white)
                
            }
            .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            
            // ProgressBar
            
            VStack {
                HStack(spacing: 4) {
                    ForEach(0..<viewModel.story[viewModel.currentImageIndex].images.count, id: \.self) { index in
                        ProgressBar(numberOfSections: 1, progress: index == viewModel.currentImageIndex ? viewModel.progress : (index < viewModel.currentImageIndex ? 1 : 0))
                            .frame(height: 6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
            }
            
        }
        
        }
    }


#Preview {
    StoryView(viewModel: StoriesViewModel())
}
