import Foundation

class WeatherDetailViewModel {
    private var cityName: String
    private var temperature: Int?
    private var date: Date?
    private var weatherForecast: [WeatherDetailTableViewCellViewModel]?
    
    init(with model: WeatherListCellViewModel) {
        self.cityName = model.name
        self.temperature = model.currentWeather?.temperature
        self.date = model.forecastWeather?.first?.date
        if let weather = model.forecastWeather {
            pepareForecast(for: weather)
        }
    }
    
    var numberOfRows: Int {
        return weatherForecast?.count ?? 0
    }
    
    var title: String {
        return cityName
    }
    
    var currentTemperature: String? {
        if let temperature = temperature {
            return "\(temperature)°"
        }
        return nil
    }
    
    var currentDate: String? {
        if let date = date {
            return WeatherDate().displayDate(from: date)
        }
        return nil
    }
    
    func pepareForecast(for weatherForecastList: [ForecastWeatherModel]) {
        self.weatherForecast = []
        for (index, forecast) in weatherForecastList.enumerated() {
            if index < 7 {
                self.weatherForecast?.append(WeatherDetailTableViewCellViewModel(date: forecast.date,
                                                                                 maxTemperature: forecast.maxTemperature,
                                                                                 minTemperature: forecast.minTemperature))
            } else {
                break
            }
        }
    }
    
    func forecastDay(for day: Int) -> WeatherDetailTableViewCellViewModel? {
        if let forecast = weatherForecast?[day] {
            return forecast
        }
        return nil
    }
}
