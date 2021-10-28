//
//  CustomSearchBar.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 10. 12..
//

import Foundation
import SwiftUI

struct CustomSearchBar: View {
    @ObservedObject var searchResult: SearchCities
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                HStack(spacing:12) {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchResult.query)
                }
                .foregroundColor(.gray)
                .padding()
                
                if !searchResult.searchedCities.isEmpty {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            withAnimation {
                                ForEach(searchResult.searchedCities, id: \.id) { city in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(city.address.name)
                                        
                                        Divider()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .frame(height: CGFloat(searchResult.searchedCities.count) * 40)
                }
            }
            .background(Color("SearchBar"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        }
    }
}
