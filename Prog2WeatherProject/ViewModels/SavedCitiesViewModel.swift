//
//  SavedCitiesViewModel.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 15..
//

import Foundation
import Combine
import CoreData

class SavedCitiesViewModel: ObservableObject {
    @Published private(set) var cities: [CityViewModel] = []

    init() {
        loadCities()
    }

    public func loadCities() {
        self.cities.removeAll()
        
        let savedCities = SavedDataManager.shared.getAllCities()
        
        for city in savedCities {
            self.appendCity(city: city)
        }
    }
    
    public func appendCity(city: City) {
        let cityViewModel = CityViewModel(city: city)
        DispatchQueue.main.async {
            self.cities.append(cityViewModel)
        }
    }
    
    public func deleteCity(cityVM: CityViewModel) {
        guard let existingCity = SavedDataManager.shared.getCityById(id: cityVM.id)
            else { return }
        
        guard let index = cities.firstIndex(of: cityVM) else { return }
        
        SavedDataManager.shared.deleteCity(city: existingCity)

        self.cities.remove(at: index)
    }
    
    public func getCityViewModelById(id: String) -> CityViewModel? {
        let indexOfCityVM = cities.firstIndex{$0.id == id}
        
        if indexOfCityVM != nil {
            return cities[indexOfCityVM!]
        }
        return nil
    }
}
