//
//  WeatherListViewModel.swift
//  VoorDieWind
//
//  Created by Andre Louw on 2019/02/14.
//  Copyright © 2019 Andre Louw. All rights reserved.
//

import Foundation

struct WeatherListViewModel {
    private var weatherViewModels = [WeatherViewModel]()
}

struct WeatherViewModel {
    let name: String
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
}


struct CitySearchListViewModel {
    var citySearchViewModels: [CitySearchViewModel]
    
    init(from model: CitySearchModel) {
        self.citySearchViewModels = []
        for city in model.search.results {
            self.citySearchViewModels.append(CitySearchViewModel(cityName: city.cityName.first?["value"] ?? ""))
        }
    }
}

struct CitySearchViewModel: Codable {
    let cityName: String
//    let area: String
}

struct CitySearchModel: Codable {
    let search: CitySearchResultModel
    
    private enum CodingKeys: String, CodingKey {
        case search = "search_api"
    }
}

struct CitySearchResultModel: Codable {
    let results: [CitySearchDetailsModel]
    
    private enum CodingKeys: String, CodingKey {
        case results = "result"
    }
}

struct CitySearchDetailsModel: Codable {
    let cityName: [Dictionary<String, String>]
    
    private enum CodingKeys: String, CodingKey {
        case cityName = "areaName"
    }
//    let country: [String]
//    let region: [String]
//    let latitude: Double
//    let longtitude: Double
//    let population: Int
//    let weatherUrl: String
}
