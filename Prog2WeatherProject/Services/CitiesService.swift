//
//  LocationService.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 12..
//

import Foundation

class CititesService {
    private var key = ConfigReader.shared.config.locationApiKey
    
    func fetchCities(query: String, completion: @escaping ((Result<[CitiesModel], NetworkError>) -> Void)) {
        guard let requestURL = buildGeocodingURL(query: query) else {
            return completion(.failure(.badURL))
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print(String(describing: response))
                completion(.failure(.badResponse))
                return
            }
            
            do {
                let json = try JSONDecoder().decode([CitiesModel].self, from: data)
                completion(.success(json))
            } catch let err {
                print(String(describing: err))
                completion(.failure(.badResponse))
            }
        }.resume()
    }
    
    private func buildGeocodingURL(query: String) -> URL? {
        let queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "key", value: self.key),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "tag", value: "place:city,place:town,place:village")
        ]
        var components = URLComponents(string: "https://eu1.locationiq.com/v1/autocomplete.php")
        components?.queryItems = queryItems
        
        return components?.url
    }
}
