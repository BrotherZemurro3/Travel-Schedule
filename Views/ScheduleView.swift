//
//  ScheduleView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import SwiftUI

struct ScheduleView: View {
    
    @State private var viewModel = SourceViewModel()
    @State private var from: String = "Откуда"
    @State private var to: String = "Куда"
    @State private var fromToToggle = true
    
    var body: some View {
        VStack(spacing: 44) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .center, spacing: 12) {
                    ForEach(viewModel.story) { story in
                        StoriesCell(stories: story)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 140)
            .scrollIndicators(.hidden)
            
            VStack(spacing: 16) {
                ZStack {
                    Color(UIColor(resource: .blueUniversal))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(fromToToggle ? from : to)
                                .foregroundStyle(fromToToggle ? (from == "Откуда" ? .grayUniversal : .blackUniversal) : (to == "Куда" ? .grayUniversal : .blackUniversal))
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(fromToToggle ? to : from)
                                .foregroundStyle(fromToToggle ? (to == "Куда" ? .grayUniversal : .blackUniversal) : (from == "Откуда" ? .grayUniversal : .blackUniversal))
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        )
                        .padding(.horizontal, 16)
                        
                        Button(action: { fromToToggle.toggle() }) {
                            Image("ChangeButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.blue)
                                .padding(6)
                                .background(.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.vertical, 16)
                }
                .frame(height: 128)
                .padding(.horizontal, 16)
                

            }
            
            Spacer()
            
            Divider()
                .frame(height: 3)
        }
        .padding(.top, 24)
    }
}

#Preview {
    ScheduleView()
}
