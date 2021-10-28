//
//  SearchCity.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 12..
//

import Foundation
import SwiftUI

class SearchCities: ObservableObject {
    var citiesService = CititesService()
    
    @Published var searchedCities: [CitiesModel] = []
    
    @Published var query = ""
    
    @Published var page = 1
    
    func find() {
        citiesService.fetchCities(query: query) { result in
            switch result {
            case .success(let cities):
                DispatchQueue.main.async {
                    
                    if self.page == 1 {
                        self.searchedCities.removeAll()
                    }
                    
                    self.searchedCities.append(contentsOf: cities)
                }
            case .failure(_):
                print("failure")
            }
        }
    }
}
