//
//  CurrentLocationView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 21..
//

import SwiftUI

struct CurrentLocationView: View {
    @StateObject var viewModel: CurrentLocationViewModel
    
    var dateTimeManager = DateTimeManager()
    
    var body: some View {
        if viewModel.isFetching {
            ProgressView()
            .onAppear {
                viewModel.fetchData()
            }
        } else {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(dateTimeManager.epochToDay(timestamp: viewModel.current.datetime)),")
                            Text(dateTimeManager.epochToHumanDate(timestamp: viewModel.current.datetime), style: .time)
                        }.font(.title3).foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                Spacer()
                
                Image(systemName: viewModel.iconMap[viewModel.current.weatherMain] ?? viewModel.defaultIcon)
                    .font(.system(size: 70))
                Text("\(String(format: "%.0f", (viewModel.current.temperature)) )º")
                    .bold()
                    .font(.system(size: 70))
                Text(viewModel.current.weatherDescription)
                    .font(.title2)
                    .foregroundColor(.secondary)
                HStack {
                    Text("\(String(format: "H: %.0f", (viewModel.daily[0].temperature.max)) )º")
                    Text("\(String(format: "L: %.0f", (viewModel.daily[0].temperature.min)) )º")
                }.font(.title3).foregroundColor(.secondary)
                
                Spacer()
                
                ZStack {
                    Color(.systemGray6)
                    
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(viewModel.hourly, id: \.id) { hourly in
                                VStack {
                                    Text(dateTimeManager.epochToHumanDate(timestamp: hourly.datetime), style: .time)
                                        .foregroundColor(.primary)
                                        .font(.subheadline)
                                        .frame(width: 75)
                                        .padding(.top, 4)
                                    
                                    Spacer()
                                    
                                    Image(systemName: viewModel.iconMap[hourly.main] ?? viewModel.defaultIcon)
                                        .font(.system(size: 25))
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.0f", (hourly.temperature)) )º")
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
                        ForEach(viewModel.daily.dropFirst(), id: \.id) { daily in
                            HStack {
                                Text(dateTimeManager.epochToDayL(timestamp: daily.datetime))
                                
                                Spacer()
                                
                                Image(systemName: viewModel.iconMap[daily.main] ?? viewModel.defaultIcon)
                                    .font(.system(size: 25))
                                
                                Spacer()
                                
                                Text("\(String(format: "H: %.0f", (daily.temperature.max)) )º")
                                
                                Spacer()
                                
                                Text("\(String(format: "L: %.0f", (daily.temperature.min)) )º")
                            }
                            .frame(height: 25)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .cornerRadius(10.0)
            .padding()
            .navigationTitle(viewModel.cityName)
            .toolbar {
                Menu {
                    Button(action: {
                        viewModel.fetchData()
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
}
