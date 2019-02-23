import Foundation

struct WeatherModel: Decodable {
    let data: WeatherDataModel
    
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

struct WeatherDataModel: Decodable {
    let current: [CurrentWeatherModel]
    let forecast: [ForecastWeatherModel]
    
    private enum CodingKeys: String, CodingKey {
        case current = "current_condition"
        case forecast = "weather"
    }
    
    init(current: [CurrentWeatherModel], forecast: [ForecastWeatherModel]) {
        self.current = current
        self.forecast = forecast
    }
}

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
            
            guard let temperature = try Int(values.decode(String.self, forKey: .temperature)) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.temperature], debugDescription: "Expecting string representation of Int"))
            }
            
            guard let feelsLikeTemperature = try Int(values.decode(String.self, forKey: .feelsLikeTemperature)) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.feelsLikeTemperature], debugDescription: "Expecting string representation of Int"))
            }
            
            self.init(temperature: temperature, feelsLikeTemperature: feelsLikeTemperature)
        }
    }
}

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
            
            guard let date = try  WeatherDate().date(from: values.decode(String.self, forKey: .date)) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.date], debugDescription: "Expecting string representation of Date"))
            }
            
            guard let maxTemperature = try Int(values.decode(String.self, forKey: .maxTemperature)) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.maxTemperature], debugDescription: "Expecting string representation of Int"))
            }
            
            guard let minTemperature = try Int(values.decode(String.self, forKey: .minTemperature)) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.minTemperature], debugDescription: "Expecting string representation of Int"))
            }
            
            self.init(date: date, maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
    }
}

