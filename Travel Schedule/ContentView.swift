//
//  ContentView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 10.07.2025.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                      Button("Test API") {
                          testFetchStations()
                          testFetchAllStations()
                      }
                  }
            }
            Text("Select an item")
        }

    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
func testFetchAllStations() {
    Task {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let service = GetAllStationsService(client: client, apikey: "94795250-37d7-42dd-aa66-e6c2228ede23")
            
            
            print("Fetching All stations...")
            let stations = try await service.getAllStations()
            print("Successfully fetched All stations: \(stations)")
        } catch {
            
            print("Error fetching All stations: \(error)")
            
        }
    }
}
func testFetchStations() {
    
    Task {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let service = NearestStationsService(client: client, apikey: "94795250-37d7-42dd-aa66-e6c2228ede23")
            
            
            print("Fetching station...")
            let stations = try await service.getNearestStations(lat: 59.864177, // Пример координат
                                                                lng: 30.319163, // Пример координат
                                                                distance: 50    // Пример дистанции
            )
            print("Successfully fetched stations: \(stations)")
        } catch {
            // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
            //    она будет поймана здесь, и мы выведем её в консоль
            print("Error fetching stations: \(error)")
            // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
        }
    }
}
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    #Preview {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }

