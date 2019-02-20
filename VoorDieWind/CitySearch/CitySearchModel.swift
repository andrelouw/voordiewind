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
    let region: [JSON]
    let country: [JSON]
    let longitude: String
    let latitude: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "areaName"
        case region = "region"
        case country = "country"
        case longitude = "longitude"
        case latitude = "latitude"
    }
}