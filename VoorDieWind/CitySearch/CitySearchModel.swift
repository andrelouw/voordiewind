// MARK: - City Search Model
struct CitySearchModel: Decodable {
    let search: CitySearchResultModel
    
    private enum CodingKeys: String, CodingKey {
        case search = "search_api"
    }
}

// MARK: - City Search Result Model
struct CitySearchResultModel: Decodable {
    let results: [CityModel]
    
    private enum CodingKeys: String, CodingKey {
        case results = "result"
    }
}

// MARK: - City Model
struct CityModel: Decodable {
    let name: String
    let region: String
    let country: String
    let longitude: Double
    let latitude: Double
    
    var identifier: String {
        return "\(latitude),\(longitude)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "areaName"
        case region = "region"
        case country = "country"
        case longitude = "longitude"
        case latitude = "latitude"
    }
    
    init(name: String, region: String, country: String, longitude: Double, latitude: Double) {
        self.name = name
        self.region = region
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            let name = try WeatherServiceDecoder.decodeJSONToString(for: values, key: .name)
            let region = try WeatherServiceDecoder.decodeJSONToString(for: values, key: .region)
            let country = try WeatherServiceDecoder.decodeJSONToString(for: values, key: .country)
            let longitude = try WeatherServiceDecoder.decodeStringToDouble(for: values, key: .longitude)
            let latitude = try WeatherServiceDecoder.decodeStringToDouble(for: values, key: .latitude)
            
            self.init(name: name, region: region, country: country, longitude: longitude, latitude: latitude)
        }
    }
}
