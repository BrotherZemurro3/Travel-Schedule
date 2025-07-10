//
//  Travel_ScheduleApp.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 10.07.2025.
//

import SwiftUI

@main
struct Travel_ScheduleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
