//
//  SourceViewModel.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import Foundation
import SwiftUI
import Observation
import Combine


@Observable class StoriesViewModel {
    var story: [Stories]
    var showStoryView: Bool = false
    var currentStoryIndex: Int = 0
    var currentImageIndex: Int = 0
    
    private var timer: Timer.TimerPublisher = Timer.publish(every: 10, on: .main, in: .common)
    private var cancellable: AnyCancellable?
    init() {
            self.story = [
                Stories(previewImage: "TwoPassengersPreview", images: ["TwoPassengersBig","musiciansBig"]),
                Stories(previewImage: "TrainMountainPreview", images: ["TrainMountainBig","winterTrainBig"]),
                Stories(previewImage: "TrainFloversPreview", images: ["TrainFloversBig", "indianTrainBig"]),
                Stories(previewImage: "PassengersPreview", images: ["PassengersBig", "leaderBig"]),
                Stories(previewImage: "ManWithAccordionPreview", images: ["ManWithAccordionBig", "musiciansBig"]),
                Stories(previewImage: "MachineWorkerPreview", images: ["MachineWorkerBig", "stationWorkerBig"]),
                Stories(previewImage: "GrannyWithVegetablesPreview", images: ["GrannyWithVegetablesBig", "pumpkinTrainBig"]),
                Stories(previewImage: "FreeSpacePreview", images: ["FreeSpaceBig", "ambientBig"]),
                Stories(previewImage: "ConductorGirlPreview", images: ["ConductorGirlBig", "ConductorGirlTwoBig"])
            ]
        }
    
    func startTimer() {
        timer = Timer.publish(every: 10, on: .main, in: .common)
        cancellable = timer
            .autoconnect()
            .sink {}
        
    }
}
