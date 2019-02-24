import Foundation

/// MARK: - Weather Model
struct WeatherModel: Decodable {
    var data: WeatherDataModel
    
    var current: CurrentWeatherModel? {
        return data.current.first
    }
    
    var forecast: [ForecastWeatherModel] {
      return data.forecast
    }
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(data: WeatherDataModel) {
        self.data = data
    }
}

/// MARK: - Weather Data Model
struct WeatherDataModel: Decodable {
    var current: [CurrentWeatherModel]
    var forecast: [ForecastWeatherModel]
    
    private enum CodingKeys: String, CodingKey {
        case current = "current_condition"
        case forecast = "weather"
    }
    
    init(current: [CurrentWeatherModel], forecast: [ForecastWeatherModel]) {
        self.current = current
        self.forecast = forecast
    }
}

/// MARK: - Current Weather
struct CurrentWeatherModel: Decodable {
    let temperature: Int
    let feelsLikeTemperature: Int
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp_C"
        case feelsLikeTemperature = "FeelsLikeC"
    }
    
    init(temperature: Int, feelsLikeTemperature: Int) {
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            let temperature = try WeatherServiceDecoder.decodeStringToInt(for: values, key: .temperature)
            let feelsLikeTemperature = try WeatherServiceDecoder.decodeStringToInt(for: values, key: .feelsLikeTemperature)
            
            self.init(temperature: temperature, feelsLikeTemperature: feelsLikeTemperature)
        }
    }
}

/// MARK: - Forecast Weather
struct ForecastWeatherModel: Decodable {
    let date: Date
    let maxTemperature: Int
    let minTemperature: Int
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case maxTemperature = "maxtempC"
        case minTemperature = "mintempC"
    }
    
    init(date: Date, maxTemperature: Int, minTemperature: Int) {
        self.date = date
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            let date = try WeatherServiceDecoder.decodeStringToDate(for: values, key: .date)
            let maxTemperature = try WeatherServiceDecoder.decodeStringToInt(for: values, key: .maxTemperature)
            let minTemperature = try WeatherServiceDecoder.decodeStringToInt(for: values, key: .minTemperature)
            
            self.init(date: date, maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
    }
}

