//
//  ContentView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 09. 28..
//

import SwiftUI
import CoreData

struct ContentView: View {
    private var weatherService: WeatherService = WeatherService()
    @ObservedObject var savedCitiesVM = SavedCitiesViewModel()
    @StateObject var searchData = SearchCities()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var currentLocationVM = CurrentLocationViewModel()
    
    func removeCity(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        savedCitiesVM.deleteCity(cityVM: savedCitiesVM.cities[index])
    }

    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchResult: searchData, citiesVM: savedCitiesVM)
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
                    ForEach(savedCitiesVM.cities, id: \.id) { item in
                        NavigationLink {
                            WeatherView(weather: item)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.cityName)
                                    .font(.title3)
                                Text(item.country)
                                    .font(.subheadline)
                            }
                        }
                        .contextMenu
                        {
                            Button(action: {
                                savedCitiesVM.deleteCity(cityVM: item)
                            }, label:
                            {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                }
                            })
                        }
                    }
                    .onDelete(perform: removeCity)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Weather")
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
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
