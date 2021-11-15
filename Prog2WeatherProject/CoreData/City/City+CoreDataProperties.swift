//
//  City+CoreDataProperties.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 15..
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }
    
    @nonobjc public class func sortedFetchRequest() -> NSFetchRequest<City> {
        let request = NSFetchRequest<City>(entityName: "City")
        let sortDescriptor = NSSortDescriptor(keyPath: \City.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }

    @NSManaged public var country: String?
    @NSManaged public var identifier: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var name: String?
    @NSManaged public var timezone: String?

}

extension City : Identifiable {

}
