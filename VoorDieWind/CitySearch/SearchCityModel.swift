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
    let name: [JSON]
    
    private enum CodingKeys: String, CodingKey {
        case name = "areaName"
    }
    //    let country: [String]
    //    let region: [String]
    //    let latitude: Double
    //    let longtitude: Double
    //    let population: Int
    //    let weatherUrl: String
}
