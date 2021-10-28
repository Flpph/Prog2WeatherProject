//
//  WeatherViewModel.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 11..
//

import Foundation

class WeatherViewModel: ObservableObject {
    var weatherService = WeatherService()
    
    var cityName: String
    var lat: Double
    var lon: Double
    var timezone: String
    @Published var current: CurrentWeather
    @Published var hourly: [HourlyWeather]
    @Published var daily: [DailyWeather]
    @Published var error: Error?
    
    init() {
        self.cityName = "Unknown"
        self.lat = 0.0
        self.lon = 0.0
        self.timezone = "Unknown"
        self.current = CurrentWeather(datetime: 0, temperature: 0.0, feels_like: 0.0, pressure: 0, humidity: 0, visibility: 0, wind_speed: 0.0, uvi: 0.0, weather: [CurrentWeatherDescription(main: "Unknown", description: "Unknown")])
        self.hourly = [HourlyWeather(datetime: 0, temperature: 0.0, weather: [CurrentWeatherDescription(main: "Unknown", description: "Unknown")])]
        self.daily = [DailyWeather(datetime: 0, temperature: DailyWeatherTemperature(min: 0.0, max: 0.0), weather: [CurrentWeatherDescription(main: "Unknown", description: "Unknown")])]
    }
    
    func fetchData(cityName: String, lat: Double, lon: Double) {
        weatherService.getWeatherForCity(lat: lat, lon: lon) { result in
            guard let data = result else {
                return
            }
            DispatchQueue.main.async {
                self.lat = data.lat
                self.lon = data.lon
                self.current = data.current
                self.timezone = data.timezone
                self.hourly = data.hourly
                self.daily = data.daily
            }

        }
    }
}
