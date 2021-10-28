//
//  WeatherService.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 11..
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case badURL
    case noData
    case badResponse
}

class WeatherService {
    private var appId =  ConfigReader.shared.config.openWeatherAppId
    
    func getWeatherForCity(lat: Double, lon: Double, completion: @escaping ((WeatherAPIResponse?) -> Void)) {
        guard let requestURL = buildWeatherURL(lat: lat, lon: lon) else {
            return completion(nil)
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data, error == nil else {
                return completion(nil)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print(String(describing: response))
                completion(nil)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
                completion(json)
            } catch let err {
                print(String(describing: err))
                completion(nil)
            }
        }.resume()
    }
    
    private func buildWeatherURL(lat: Double, lon: Double) -> URL? {
        let queryItems = [
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "appid", value: self.appId),
            URLQueryItem(name: "exclude", value: "minutely"),
            URLQueryItem(name: "units", value: "metric")
        ]
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/onecall")
        components?.queryItems = queryItems
        
        return components?.url
    }
}
