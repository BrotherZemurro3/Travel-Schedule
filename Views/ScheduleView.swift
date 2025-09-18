//
//  ScheduleView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import SwiftUI

struct ScheduleView: View {
    @Environment(TravelViewModel.self) private var travelViewModel
    @Environment(CarrierRouteViewModel.self) private var carrierViewModel
    
    @State private var storiesViewModel = StoriesViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 44) {
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .center, spacing: 12) {
                        ForEach(storiesViewModel.story) { story in
                            StoriesCell(stories: story)
                                .environment(storiesViewModel)
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
                                Button(action: {
                                    travelViewModel.navigationPath.append(ContentView.Destination.cities(isSelectingFrom: true))
                                }) {
                                    Text(travelViewModel.fromText)
                                        .foregroundStyle(travelViewModel.fromCity == nil ? .grayUniversal : .blackUniversal)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Button(action: {
                                    travelViewModel.navigationPath.append(ContentView.Destination.cities(isSelectingFrom: false))
                                }) {
                                    Text(travelViewModel.toText)
                                        .foregroundStyle(travelViewModel.toCity == nil ? .grayUniversal : .blackUniversal)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                            )
                            .padding(.horizontal, 16)
                            
                            Button(action: {
                                travelViewModel.swapCities()
                            }) {
                                Image("ChangeButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 34)
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
                    
                    if travelViewModel.canSearch {
                        Button(action: {
                            if let fromCity = travelViewModel.fromCity,
                               let fromStation = travelViewModel.fromStation,
                               let toCity = travelViewModel.toCity,
                               let toStation = travelViewModel.toStation {
                                travelViewModel.navigationPath.append(ContentView.Destination.carriers(
                                    fromCity: fromCity,
                                    fromStation: fromStation,
                                    toCity: toCity,
                                    toStation: toStation
                                ))
                            }
                        }) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 150, height: 40)
                                .padding(.vertical, 12)
                                .background(Color(UIColor(resource: .blueUniversal)))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                Spacer()
                
                Divider()
                    .frame(height: 3)
            }
            .padding(.top, 24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .tabBar)
            .fullScreenCover(isPresented: $storiesViewModel.showStoryView) {
                StoryView(viewModel: storiesViewModel)
            }
        }
    }
}
#Preview {
    ScheduleView()
        .environment(TravelViewModel())
        .environment(CarrierRouteViewModel())
}
