//
//  LocationAPIResponse.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 12..
//

import Foundation


struct CitiesModel: Decodable {
    var id: String
    var lat: String
    var lon: String
    var address: Address
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case lat,lon,address
    }
}

struct Address: Codable, Equatable {
    var name: String
    var country: String
}

struct ReverseGeocodingResponse: Decodable {
    var id: String
    var lat: String
    var lon: String
    var displayName: String
    var address: GeoAddress
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case displayName = "display_name"
        case lat,lon,address
    }
}

struct GeoAddress: Codable {
    var county: String
    var country: String
    var city: String?
    var village: String?
    var town: String?
}
