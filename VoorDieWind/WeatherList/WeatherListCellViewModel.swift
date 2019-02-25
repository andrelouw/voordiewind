import Foundation

protocol WeatherListCellViewModelDelegate {
    func weatherListCellViewModel(_ viewModel: WeatherListCellViewModel, didUpdate weather: CityWeatherModel?)
    func weatherListCellViewModel(_ viewModel: WeatherListCellViewModel, didUpdate loadingStatus: Bool)
}

class WeatherListCellViewModel {
    var cityWeather: CityWeatherModel
    var delegate: WeatherListCellViewModelDelegate?
    
    private var notificationCenter: NotificationCenter
    
    private(set) var isUpdating: Bool = false {
        didSet {
            delegate?.weatherListCellViewModel(self, didUpdate: isUpdating)
        }
    }
    
    init(with cityWeather: CityWeatherModel) {
        self.notificationCenter = .default
        self.cityWeather = cityWeather
        if cityWeather.weather?.current == nil {
            updateWeather()
        }
    }
}

// MARK: - Public
extension WeatherListCellViewModel {
    func updateWeather() {
        isUpdating = true
        CityWeatherStore.shared.updateWeather(for: cityWeather.id) { [weak self] result in
            guard let result = result, let strongSelf = self else { return }
           
            strongSelf.cityWeather = result
            strongSelf.isUpdating = false
            strongSelf.delegate?.weatherListCellViewModel(strongSelf, didUpdate: strongSelf.cityWeather)
            strongSelf.notificationCenter.post(name: .weatherUpdated, object: strongSelf.cityWeather)
            print("Updated \(String(describing: strongSelf.cityWeather.city.name))")
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

// MARK: - Notificication
extension Notification.Name {
    static var weatherUpdated: Notification.Name {
        return .init(rawValue: "WeatherListCell.updatedWeather")
    }
}
