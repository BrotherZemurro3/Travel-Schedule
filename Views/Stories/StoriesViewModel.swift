//
//  StoriesViewModel.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import Foundation
import SwiftUI
import Combine
@Observable
class StoriesViewModel {
     var story: [Stories]
     var showStoryView: Bool = false
     var currentStoryIndex: Int = 0
     var currentImageIndex: Int = 0
     var progress: CGFloat = 0.0
     var viewedStories: Set<UUID> = []
    
    
    private var timer: Timer.TimerPublisher = Timer.publish(every: 0.05, on: .main, in: .common)
    private var cancellable: AnyCancellable?
    private let imageDuration: TimeInterval = 10.0 
    
    init() {
        self.story = [
            Stories(previewImage: "TwoPassengersPreview", images: ["TwoPassengersBig", "musiciansBig"]),
            Stories(previewImage: "TrainMountainPreview", images: ["TrainMountainBig", "winterTrainBig"]),
            Stories(previewImage: "TrainFloversPreview", images: ["TrainFloversBig", "indianTrainBig"]),
            Stories(previewImage: "PassengersPreview", images: ["PassengersBig", "leaderBig"]),
            Stories(previewImage: "ManWithAccordionPreview", images: ["ManWithAccordionBig", "musiciansBig"]),
            Stories(previewImage: "MachineWorkerPreview", images: ["MachineWorkerBig", "stationWorkerBig"]),
            Stories(previewImage: "GrannyWithVegetablesPreview", images: ["GrannyWithVegetablesBig", "pumpkinTrainBig"]),
            Stories(previewImage: "FreeSpacePreview", images: ["FreeSpaceBig", "ambientBig"]),
            Stories(previewImage: "ConductorGirlPreview", images: ["conductorGirlBig", "ConductorGirlTwoBig"])
        ]
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
        cancellable = timer
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.linear(duration: 0.05)) {
                    self.progress += 0.05 / self.imageDuration
                    if self.progress >= 1.0 {
                        self.navigateForward()
                    }
                }
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        withAnimation(.linear) {
            progress = 0.0
        }
    }
    
    func navigateForward() {
        withAnimation(.linear) {
            progress = 0.0
        }
        if currentImageIndex < story[currentStoryIndex].images.count - 1 {
            currentImageIndex += 1
            viewedStories.insert(story[currentStoryIndex].id)
        } else if currentStoryIndex < story.count - 1 {
            viewedStories.insert(story[currentStoryIndex].id)
            currentStoryIndex += 1
            currentImageIndex = 0
            viewedStories.insert(story[currentStoryIndex].id)
        } else {
            viewedStories.insert(story[currentStoryIndex].id)
            currentStoryIndex = 0
            currentImageIndex = 0
            stopTimer()
            showStoryView = false
        }
    }
    
    func navigateBackward() {
        withAnimation(.linear) {
            progress = 0.0
        }
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            viewedStories.insert(story[currentStoryIndex].id)
        } else if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            currentImageIndex = story[currentStoryIndex].images.count - 1
            viewedStories.insert(story[currentStoryIndex].id)
        } else {
            currentStoryIndex = 0
            currentImageIndex = 0
            stopTimer()
            showStoryView = false
        }
    }
    
    func selectStory(at index: Int) {
        currentStoryIndex = index
        currentImageIndex = 0
        withAnimation(.linear) {
            progress = 0.0
        }
        viewedStories.insert(story[currentStoryIndex].id)
        showStoryView = true
    }
    
    func isStoryViewed(_ story: Stories) -> Bool {
        return viewedStories.contains(story.id)
    }
}
