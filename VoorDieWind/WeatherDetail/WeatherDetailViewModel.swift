import Foundation

class WeatherDetailViewModel {
    var cityName: String
    var currentTemperature: String?
    var currentWeatherDate: String?
    var weatherForecast: [WeatherDetailTableViewCellViewModel]?
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    lazy var todayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    lazy var calendar: Calendar = {
       return Calendar(identifier: .gregorian)
    }()
    
    init(with model: WeatherViewModel) {
        self.cityName = model.name
        self.currentTemperature = currentTemperature(from: model.currentWeather?.temperature)
        self.currentWeatherDate = todayDateString(from: model.forecastWeather?.first?.date)
        if let weather = model.forecastWeather {
            pepareForecast(for: weather)
        }
    }
    
    var numberOfRows: Int {
        return weatherForecast?.count ?? 0
    }
    
    private func currentTemperature(from string: String?) -> String? {
        if let temperature = string {
            return "\(temperature)°"
        }
        return nil
    }
    
    func todayDateString(from dateString: String?) -> String? {
        if let string = dateString,
            let date = dateFormatter.date(from: string) {
            return todayDateFormatter.string(from: date)
        }
        return nil
    }
    
    func pepareForecast(for weatherForecastList: [ForecastWeatherModel]) {
        self.weatherForecast = []
        for (index, forecast) in weatherForecastList.enumerated() {
            if index < 7 {
                if let date = weekDay(for: forecast.date) {
                    self.weatherForecast?.append(WeatherDetailTableViewCellViewModel(date: date,
                                                                                     maxTemperature: forecast.maxTemperature,
                                                                                     minTemperature: forecast.minTemperature))
                }
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

extension WeatherDetailViewModel {
    func weekDay(for dateString: String) -> String? {
        guard  let date = dateFormatter.date(from: dateString) else { return nil }
        
        return dateFormatter.weekdaySymbols[calendar.component(.weekday, from: date) - 1]
    }
}
