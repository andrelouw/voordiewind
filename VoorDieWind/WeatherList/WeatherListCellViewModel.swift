import Foundation

protocol WeatherViewModelDelegate {
    // TODO: FIX THIS
    func weather(_ viewModel: WeatherListCellViewModel, didFinish update: Bool)
}

class WeatherListCellViewModel {
    var cityWeather: CityWeatherModel
    var delegate: WeatherViewModelDelegate?
    private var notificationCenter: NotificationCenter
    
    private(set) var isUpdating: Bool = false {
        didSet {
            self.updateWeatherLoadingStatus?(isUpdating)
        }
    }
    
    var didUpdateCurrentWeather: (() -> ())?
    var updateWeatherLoadingStatus: ((_ isUpdating: Bool) -> ())?
    
    init(with cityWeather: CityWeatherModel) {
        self.notificationCenter = .default
        self.cityWeather = cityWeather
        if cityWeather.weather?.current == nil {
            updateWeather()
        }
    }
    
    func updateWeather() {
        isUpdating = true
        CityWeatherStore.shared.updateWeather(for: cityWeather.id) { [weak self] result in
            if let result = result {
                self?.cityWeather = result
            }
            self?.isUpdating = false
            self?.didUpdateCurrentWeather?()
            self?.notificationCenter.post(name: .weatherUpdated, object: self?.cityWeather ?? nil)
            print("Updated \(String(describing: self?.cityWeather.city.name))")
        }
    }
}

// MARK: - Labels
extension WeatherListCellViewModel {
    var cityName: String {
        return cityWeather.city.name
    }
    
    var temperature: String? {
        if let temp = cityWeather.weather?.current?.temperature {
            return "\(temp)°"
        } else {
            return "-"
        }
    }
    
    var feelsLike: String? {
        if let temp = cityWeather.weather?.current?.feelsLikeTemperature{
            return "Feels like: \(temp)°"
        } else {
            return nil
        }
    }
}


extension Notification.Name {
    static var weatherUpdated: Notification.Name {
        return .init(rawValue: "WeatherListCell.updatedWeather")
    }
}
