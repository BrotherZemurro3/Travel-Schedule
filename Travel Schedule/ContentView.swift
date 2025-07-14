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
    @State private var consoleOutput: String = "Console ready. Select an API test from the menu."
    
    var body: some View {
        NavigationView {
            VStack {
                // Консольный вывод в верхней части экрана
                ScrollView {
                    Text(consoleOutput)
                        .font(.system(size: 14, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding([.horizontal, .top])
                }
                .frame(maxHeight: 200)
                
                // Список элементов ниже консоли
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
                .listStyle(PlainListStyle())
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
                    Menu("Test API") {
                        Button("Test All Stations") {
                            testFetchAllStations()
                        }
                        Button("Test NearestStations") {
                            testFetchStations()
                        }
                        Button("Test NearestCities"){
                            testFetchNearestCities()
                        }
                    }
                }
            }
            .navigationTitle("Travel Schedule")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
                appendToConsole("New item added at \(itemFormatter.string(from: Date()))")
            } catch {
                let nsError = error as NSError
                appendToConsole("Error adding item: \(nsError.localizedDescription)")
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
                appendToConsole("Deleted \(offsets.count) item(s)")
            } catch {
                let nsError = error as NSError
                appendToConsole("Error deleting items: \(nsError.localizedDescription)")
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func appendToConsole(_ message: String) {
        DispatchQueue.main.async {
            let timestamp = itemFormatter.string(from: Date())
            consoleOutput += "\n[\(timestamp)] \(message)"
        }
    }
    
    private func testFetchAllStations() {
        appendToConsole("Starting All Stations API test...")
        Task {
            do {
                let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
                let service = GetAllStationsService(client: client, apikey: "94795250-37d7-42dd-aa66-e6c2228ede23")
                
                let stations = try await service.getAllStations()
                appendToConsole("Successfully fetched \(stations) stations")
            } catch {
                appendToConsole("Error fetching All stations: \(error.localizedDescription)")
            }
        }
    }
    
    private func testFetchStations() {
        appendToConsole("Starting Nearest Stations API test...")
        Task {
            do {
                let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
                let service = NearestStationsService(client: client, apikey: "94795250-37d7-42dd-aa66-e6c2228ede23")
                
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                appendToConsole("Successfully fetched \(stations) nearest stations")
            } catch {
                appendToConsole("Error fetching nearest stations: \(error.localizedDescription)")
            }
        }
    }
    private func testFetchNearestCities() {
        appendToConsole("Starting Nearest Cities API test...")
        Task {
            do {
                let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
                let service = NearestCityService(client: client, apikey: "94795250-37d7-42dd-aa66-e6c2228ede23")
                let cities = try await service.getNearestCities(lat: 59.864177, lng: 30.319163)
                appendToConsole("Successfully fetched \(cities) cities")
            } catch {
                appendToConsole("Error fetching cities: \(error.localizedDescription)")
            }
        }
        
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
