//
//  WeatherView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 15..
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var weather: WeatherViewModel
    
    var dateTimeManager = DateTimeManager()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(dateTimeManager.epochToDay(timestamp: weather.current.datetime)),")
                        Text(dateTimeManager.epochToHumanDate(timestamp: weather.current.datetime), style: .time)
                    }.font(.title3).foregroundColor(.secondary)
                }
                Spacer()
            }
            
            Spacer()
            
            Image(systemName: weather.iconMap[weather.current.weatherMain] ?? weather.defaultIcon).font(.system(size: 70))
            Text("\(String(format: "%.0f", weather.current.temperature) == "0" ? "__" : "\(String(format: "%.0f", (weather.current.temperature)) )")º").bold().font(.system(size: 70))
            Text(weather.current.weatherDescription).font(.title2).foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .onAppear {
            weather.fetchData(cityName: weather.cityName, lat: weather.lat, lon: weather.lon)
        }
        .navigationTitle(Text("\(weather.cityName == "" ? "City" : weather.cityName)"))
        .toolbar {
            Menu {
                Button(action: {
                    weather.fetchData(cityName: weather.cityName, lat: weather.lat, lon: weather.lon)
                }, label: {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh Weather Data")
                })
            } label: {
                Image(systemName: "ellipsis").font(.title3).foregroundColor(.primary)
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: WeatherViewModel())
    }
}
