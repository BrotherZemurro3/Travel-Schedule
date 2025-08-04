//
//  SourceViewModel.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import Foundation
import SwiftUI
import Observation


@Observable class StoriesViewModel {
    var story: [Stories]
    var showStoryView: Bool = false
    
    init() {
            self.story = [
                Stories(previewImage: "TwoPassengersPreview", BigImage: "TwoPassengersBig"),
                Stories(previewImage: "TrainMountainPreview", BigImage: "TrainMountainBig"),
                Stories(previewImage: "TrainFloversPreview", BigImage: "TrainFloversBig"),
                Stories(previewImage: "PassengersPreview", BigImage: "PassengersBig"),
                Stories(previewImage: "ManWithAccordionPreview", BigImage: "ManWithAccordionBig"),
                Stories(previewImage: "MachineWorkerPreview", BigImage: "MachineWorkerBig"),
                Stories(previewImage: "GrannyWithVegetablesPreview", BigImage: "GrannyWithVegetablesBig"),
                Stories(previewImage: "FreeSpacePreview", BigImage: "FreeSpaceBig"),
                Stories(previewImage: "ConductorGirlPreview", BigImage: "ConductorGirlBig")
            ]
        }
}
