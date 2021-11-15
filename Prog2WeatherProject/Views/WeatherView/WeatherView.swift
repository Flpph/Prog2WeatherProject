//
//  WeatherView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 15..
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var weather: WeatherViewModel
    
    var body: some View {
        Text(weather.cityName)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: WeatherViewModel())
    }
}
