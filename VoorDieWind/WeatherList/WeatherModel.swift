struct WeatherModel: Codable {
    let data: WeatherDataModel
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct WeatherDataModel: Codable {
    let current: [CurrentWeatherModel]
    let forecast: [ForecastWeatherModel]
    
    private enum CodingKeys: String, CodingKey {
        case current = "current_condition"
        case forecast = "weather"
    }
}

struct CurrentWeatherModel: Codable {
    let temperature: String
    let feelsLike: String
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp_C"
        case feelsLike = "FeelsLikeC"
    }
}

struct ForecastWeatherModel: Codable {
    let date: String
    let maxTemperature: String
    let minTemperature: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case maxTemperature = "maxtempC"
        case minTemperature = "mintempC"
    }
}

