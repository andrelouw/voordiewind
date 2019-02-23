import Foundation

class WeatherDetailViewModel {
    private var cityWeatherModel: CityWeatherModel
    
    init(with model: CityWeatherModel) {
        self.cityWeatherModel = model
    }
    
    var numberOfRows: Int {
        if let count = cityWeatherModel.forecastWeather?.count {
            if count > 7 {
                return 7
            }
            return count
        }
        return 0
    }
    
    var title: String {
        return cityWeatherModel.city.name
    }
    
    var currentTemperature: String? {
        if let temperature = cityWeatherModel.currentWeather?.temperature {
            return "\(temperature)°"
        }
        return nil
    }
    
    var currentDate: String? {
        if let date = cityWeatherModel.forecastWeather?.first?.date {
            return WeatherDate().displayDate(from: date)
        }
        return nil
    }
    
    func forecast(for indexPath: IndexPath) ->  ForecastWeatherModel? {
        return cityWeatherModel.forecastWeather?[safe: indexPath.row]
    }
    
//    func pepareForecast(for weatherForecastList: [ForecastWeatherModel]) {
//        self.weatherForecast = []
//        for (index, forecast) in weatherForecastList.enumerated() {
//            if index < 7 {
//                self.weatherForecast?.append(WeatherDetailTableViewCellViewModel(date: forecast.date,
//                                                                                 maxTemperature: forecast.maxTemperature,
//                                                                                 minTemperature: forecast.minTemperature))
//            } else {
//                break
//            }
//        }
//    }
    
//    func forecastDay(for day: Int) -> WeatherDetailTableViewCellViewModel? {
//        if let forecast = weatherForecast?[day] {
//            return forecast
//        }
//        return nil
//    }
}
