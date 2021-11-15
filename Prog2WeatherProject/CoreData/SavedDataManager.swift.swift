//
//  SavedDataManager.swift.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 09..
//

import Foundation
import CoreData

class SavedDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = SavedDataManager()
    
    var viewContext: NSManagedObjectContext {
        let viewContext = persistentContainer.viewContext
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
        return viewContext
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Error saving context in CoreData Error: \(error.localizedDescription)")
        }
    }
    
    func getAllCities() -> [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getCityById(id: String) -> City? {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "identifier == %@", id)
        
        guard let res = (try? viewContext.fetch(request)) else { return nil }
        
        return res.first
    }
    
    func deleteCity(city: City) {
        viewContext.delete(city)
        
        save()
    }
    
    func deleteCityByVM(cityVM: WeatherViewModel) {
        guard let city = getCityById(id: cityVM.id) else {
            return
        }
        
        viewContext.delete(city)
        
        save()
    }
    
    func addCity(city: CitiesModel) {
        let entity = City(context: viewContext)
        entity.country = city.address.country
        entity.timezone = "Unknown" // Needs to be fetched
        entity.identifier = city.id
        entity.lat = city.lat
        entity.lon = city.lon
        entity.name = city.address.name
        
        save()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Prog2WeatherProject")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Task \(error)")
            }
        }
    }
}
