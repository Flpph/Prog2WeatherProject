//
//  ContentView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 09. 28..
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    private var weatherService: WeatherService = WeatherService()
    @StateObject var searchData = SearchCities()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var currentLocationVM = CurrentWeatherViewModel()

    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchResult: searchData)
                List {
                    // Current Location at the top of the list. (Disabled when current location is not accessable.)
                    NavigationLink {
                        CurrentLocationView(viewModel: currentLocationVM)
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Current Location")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .disabled(locationManager.statusString == "restricted" || locationManager.statusString == "denied"
                              || locationManager.statusString == "notDetermined")
                    .deleteDisabled(true)
                    
                    // Saved cities.
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                                .font(.title3)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .navigationTitle("Cities")
            .onChange(of: searchData.query) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if newValue == searchData.query {
                        if searchData.query != "" {
                            searchData.page = 1
                            searchData.find()
                        } else {
                            searchData.searchedCities.removeAll()
                        }
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
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
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
