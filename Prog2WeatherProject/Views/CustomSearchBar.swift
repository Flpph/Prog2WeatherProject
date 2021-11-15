//
//  CustomSearchBar.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 12..
//

import Foundation
import SwiftUI
import CoreData

struct CustomSearchBar: View {
    @ObservedObject var searchResult: SearchCities
    
    @ObservedObject var citiesVM: SavedCitiesViewModel
    
    @State private var showRemoveAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                HStack(spacing:12) {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchResult.query)
                }
                .foregroundColor(.gray)
                .padding()
                
                if !searchResult.searchedCities.isEmpty {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            withAnimation {
                                ForEach(searchResult.searchedCities, id: \.id) { city in
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text(city.address.name)
                                            Spacer()
                                            Button(action: {
                                                if isCitySaved(cityName: city.address.name) {
                                                    self.showRemoveAlert.toggle()
                                                } else {
                                                    self.saveCity(city: city)
                                                }
                                            }, label: {
                                                HStack {
                                                    Image(systemName: isCitySaved(cityName: city.address.name) ? "bookmark.fill" : "bookmark")
                                                    Text(isCitySaved(cityName: city.address.name) ? "SAVED" : "SAVE CITY")
                                                }.padding(10)
                                            })
                                        }

                                        Divider()
                                    }
                                    .padding(.horizontal)
                                    .alert(isPresented: $showRemoveAlert, content: {
                                        Alert(
                                            title: Text("Remove City?"),
                                            message: Text("This action cannot be undone. Are you sure you want to delete this city from your library?"),
                                            primaryButton: .cancel(),
                                            secondaryButton: .destructive(Text("Delete"), action: {
                                                self.removeCity(city: city)
                                            })
                                        )
                                    })
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .frame(height: CGFloat(searchResult.searchedCities.count) * 60)
                }
            }
            .background(Color("SearchBar"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        }
    }
    func saveCity(city: CitiesModel) {
        SavedDataManager.shared.addCity(city: city)
        
        guard let cityEntity = SavedDataManager.shared.getCityById(id: city.id) else { return }
        
        citiesVM.appendCity(city: cityEntity)
    }
    
    func removeCity(city: CitiesModel) {
        guard let cityVM = citiesVM.getCityViewModelById(id: city.id) else {
            return
        }
        
        citiesVM.deleteCity(cityVM: cityVM)
    }
    
    func isCitySaved(cityName: String) -> Bool {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let res = (try? SavedDataManager.shared.viewContext.fetch(req)) as? [NSManagedObject] ?? []
        
        let num:[String] = res.compactMap {
            ($0.value(forKey: ("name")) as! String)
        }
        
        if num.contains(cityName) {
            return true
        }
        
        return false
    }
}
