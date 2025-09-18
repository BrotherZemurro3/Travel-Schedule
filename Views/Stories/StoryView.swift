//
//  StoryView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 06.08.2025.
//

import SwiftUI
import Combine

struct StoryView: View {
    @Bindable var viewModel: StoriesViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.blackUniversal.edgesIgnoringSafeArea(.all)
            
            // Display the current image
            Image(viewModel.story[viewModel.currentStoryIndex].images[viewModel.currentImageIndex])
                .resizable()
                .scaledToFit()
                .cornerRadius(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            // Text overlay
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
            
            // Progress bars
            VStack {
                HStack(spacing: 4) {
                    ForEach(0..<viewModel.story[viewModel.currentStoryIndex].images.count, id: \.self) { index in
                        ProgressBar(
                            numberOfSections: 1,
                            progress: index == viewModel.currentImageIndex ? viewModel.progress : (index < viewModel.currentImageIndex ? 1 : 0)
                        )
                        .frame(height: 6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 35)
                
                Spacer()
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.stopTimer()
                        viewModel.showStoryView = false
                        dismiss()
                    }) {
                        Image("CloseButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.top, 57)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
            
            // Navigation areas
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // Лево (25% of screen width)
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.20)
                        .onTapGesture {
                            viewModel.navigateBackward()
                        }
                    
                    // центр (50% области, действия нет)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: geometry.size.width * 0.50)
                    
                    // Право (15% области нажатия)
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.20)
                        .onTapGesture {
                            viewModel.navigateForward()
                        }
                }
            }
            .ignoresSafeArea()
            
            // Dismiss gesture
            .gesture(
                DragGesture()
                    .onEnded { value in
                        // Вертикальный свайп для закрытия
                        if value.translation.height > 100 {
                            viewModel.stopTimer()
                            viewModel.showStoryView = false
                            dismiss()
                        }
                        // Горизонтальный свайп влево — вперёд
                        else if value.translation.width < -50 {
                            viewModel.navigateForward()
                        }
                        // Горизонтальный свайп вправо — назад
                        else if value.translation.width > 50 {
                            viewModel.navigateBackward()
                        }
                    }
            )
            .onChange(of: viewModel.showStoryView) { _, newValue in
                if !newValue {
                    dismiss()
                }
            }
            .onAppear {
                viewModel.startTimer()
            }
            .onDisappear {
                viewModel.stopTimer()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    StoryView(viewModel: StoriesViewModel())
}
