//
//  CurrentWeatherViewModel.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 26..
//

import SwiftUI

class CurrentLocationViewModel: ObservableObject {
    private var weatherService = WeatherService()
    private var locationManager = LocationManager()
    private var citiesService = CititesService()
    
    @Published var cityName: String
    var lat: Double
    var lon: Double
    @Published var timezone: String
    @Published var current: CurrentWeather
    @Published var hourly: [HourlyWeather]
    @Published var daily: [DailyWeather]
    
    @Published var isFetching = true
    
    let defaultIcon = "questionmark"
    let iconMap = [
        "Drizzle" : "cloud.drizzle.fill",
        "Thunderstorm" : "cloud.bolt.fill",
        "Rain" : "cloud.rain.fill",
        "Snow" : "snow",
        "Clear" : "sun.max.fill",
        "Clouds" : "cloud.fill",
        "Mist" : "cloud.fog.fill",
        "Smoke" : "smoke.fill",
        "Haze" : "sun.haze.fill",
        "Dust" : "sun.dust.fill",
        "Fog" : "cloud.fog.fill",
        "Sand" : "sun.dust.fill",
        "Ash" : "smoke.fill",
        "Squall" : "wind",
        "Tornado" : "tornado"
    ]
    
    init() {
        self.lat = 0.0
        self.lon = 0.0
        self.cityName = "Unknown"
        self.timezone = "Unknown"
        self.current = CurrentWeather(datetime: 0, temperature: 0.0, feels_like: 0.0, pressure: 0, humidity: 0, visibility: 0, wind_speed: 0.0, uvi: 0.0, weather: [CurrentWeatherDescription(main: "Unknown", description: "Unknown")])
        self.hourly = [HourlyWeather(datetime: 0, temperature: 0.0, weather: [CurrentWeatherDescription(main: "Unknown", description: "Unknown")])]
        self.daily = [DailyWeather(datetime: 0, temperature: DailyWeatherTemperature(min: 0.0, max: 0.0, day: 0.0), weather: [CurrentWeatherDescription(main: "Unknown", description: "Unknown")])]
    }
    
    func fetchData() {
        self.isFetching = true
        guard let latitude = locationManager.lastLocation?.coordinate.latitude else {
            return
        }
        guard let longitude = locationManager.lastLocation?.coordinate.longitude else {
            return
        }
        citiesService.fetchReverseGeocoding(lat: latitude, lon: longitude) { result in
            guard let data = result else {
                return
            }
            DispatchQueue.main.async {
                if data.address.village != nil {
                    self.cityName = data.address.village!
                } else if data.address.town != nil {
                    self.cityName = data.address.town!
                } else if data.address.city != nil {
                    self.cityName = data.address.city!
                }
            }
        }
        weatherService.getWeatherForCity(lat: latitude, lon: longitude) { result in
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
                self.isFetching = false
            }
        }
    }
}

