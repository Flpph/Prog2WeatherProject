//
//  CurrentLocationView.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 21..
//

import SwiftUI

struct CurrentLocationView: View {
    @StateObject var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        VStack{
            Text(viewModel.timezone)
            Text(viewModel.cityName)
            Text(String(viewModel.lon))
            Text(String(viewModel.lat))
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct CurrentLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationView(viewModel: CurrentWeatherViewModel())
    }
}
