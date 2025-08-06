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
    
    
    // Хэширование для Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
    
    static func ==(lhs: Stories, rhs: Stories) -> Bool {
        lhs.id == rhs.id
    }
}
