import Foundation

class WeatherDetailViewModel {
    private var cityWeatherModel: CityWeatherModel
    
    init(with model: CityWeatherModel) {
        self.cityWeatherModel = model
    }
    
    var numberOfRows: Int {
        if let count = cityWeatherModel.weather?.forecast.count {
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
        if let temperature = cityWeatherModel.weather?.current?.temperature {
            return "\(temperature)°"
        }
        return nil
    }
    
    var currentDate: String? {
        if let date = cityWeatherModel.weather?.forecast.first?.date {
            return WeatherDate().displayDate(from: date)
        }
        return nil
    }
    
    func forecast(for indexPath: IndexPath) ->  ForecastWeatherModel? {
        return cityWeatherModel.weather?.forecast[safe: indexPath.row]
    }
}
