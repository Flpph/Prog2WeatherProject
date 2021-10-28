//
//  Config.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 28..
//

import Foundation

struct Config: Decodable {
    let openWeatherAppId: String
    let locationApiKey: String
}

class ConfigReader {
    private(set) var config: Config
    static let shared = ConfigReader()
    
    init() {
        self.config = Config(openWeatherAppId: "", locationApiKey: "")
        
        guard let json = loadJson(filename: "config") else {
            return
        }
        self.config = json
    }
    
    private func loadJson(filename fileName: String) -> Config? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Config.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
