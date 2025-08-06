//
//  Stories.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import Foundation


struct Stories: Identifiable, Hashable {
    var id = UUID()
    var previewImage: String
    var images: [String]
}
