//
//  WeatherView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 15..
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var weather: CityViewModel
    @EnvironmentObject var savedCitiesVM: SavedCitiesViewModel
    
    var dateTimeManager = DateTimeManager()
    
    var body: some View {
        if weather.isFetching {
            ProgressView()
            .onAppear {
                weather.fetchData(cityName: weather.cityName, lat: weather.lat, lon: weather.lon)
            }
        } else {
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
                
                Image(systemName: weather.iconMap[weather.current.weatherMain] ?? weather.defaultIcon)
                    .font(.system(size: 70))
                Text("\(String(format: "%.0f", (savedCitiesVM.unit == "metric" ? weather.current.temperature : weather.current.temperature * 9/5+32)) )º")
                    .bold()
                    .font(.system(size: 70))
                Text(weather.current.weatherDescription)
                    .font(.title2)
                    .foregroundColor(.secondary)
                HStack {
                    Text("\(String(format: "H: %.0f", (savedCitiesVM.unit == "metric" ? weather.daily[0].temperature.max : weather.daily[0].temperature.max * 9/5+32)) )º")
                    Text("\(String(format: "L: %.0f", (savedCitiesVM.unit == "metric" ? weather.daily[0].temperature.min : weather.daily[0].temperature.min * 9/5+32)) )º")
                }.font(.title3).foregroundColor(.secondary)
                
                Spacer()
                
                ZStack {
                    Color(.systemGray6)
                    
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(weather.hourly, id: \.id) { hourly in
                                VStack {
                                    Text(dateTimeManager.epochToHumanDate(timestamp: hourly.datetime), style: .time)
                                        .foregroundColor(.primary)
                                        .font(.subheadline)
                                        .frame(width: 75)
                                        .padding(.top, 4)
                                    
                                    Spacer()
                                    
                                    Image(systemName: weather.iconMap[hourly.main] ?? weather.defaultIcon)
                                        .font(.system(size: 25))
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.0f", (savedCitiesVM.unit == "metric" ? hourly.temperature : hourly.temperature * 9/5+32)) )º")
                                        .foregroundColor(.primary)
                                        .font(.title3)
                                        .frame(width: 75)
                                        .padding(.bottom, 4)
                                }
                                .frame(height: 100)
                            }
                        }
                    }
                }
                .frame(height: 100)
                .cornerRadius(10.0)
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    Color(.systemGray6)
                    
                    VStack {
                        ForEach(weather.daily.dropFirst(), id: \.id) { daily in
                            HStack {
                                Text(dateTimeManager.epochToDayL(timestamp: daily.datetime))
                                
                                Spacer()
                                
                                Image(systemName: weather.iconMap[daily.main] ?? weather.defaultIcon)
                                    .font(.system(size: 25))
                                
                                Spacer()
                                
                                Text("\(String(format: "H: %.0f", (savedCitiesVM.unit == "metric" ? daily.temperature.max : daily.temperature.min * 9/5+32)) )º")
                                
                                Spacer()
                                
                                Text("\(String(format: "L: %.0f", (savedCitiesVM.unit == "metric" ? daily.temperature.min : daily.temperature.min * 9/5+32)) )º")
                            }
                            .frame(height: 25)
                            .padding(.horizontal)
                        }
                    }
                }
                .cornerRadius(10.0)
            }
            .padding()
            .navigationTitle(Text("\(weather.cityName == "" ? "City" : weather.cityName)"))
            .toolbar {
                Menu {
                    Button(action: {
                        weather.fetchData(cityName: weather.cityName, lat: weather.lat, lon: weather.lon)
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh Weather Data")
                    })
                    Picker("Unit Type", selection: $savedCitiesVM.unit) {
                        Text("Metric (C)").tag("metric")
                        Text("Imperial (F)").tag("imperial")
                    }.onChange(of: savedCitiesVM.unit, perform: { _ in
                            savedCitiesVM.changeUnit()
                    })
                } label: {
                    Image(systemName: "ellipsis").font(.title3).foregroundColor(.primary)
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: CityViewModel())
    }
}
