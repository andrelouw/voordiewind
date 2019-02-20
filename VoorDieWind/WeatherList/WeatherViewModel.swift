struct CurrentWeatherViewModel {
    var temperature: String?
    var feelsLike: String?
}

struct ForecastWeatherViewModel {
    var date: String
    var maxTemperature: String
    var minTemperature: String
}

protocol WeatherViewModelDelegate {
    func weather(_ viewModel: WeatherViewModel, didFinish update: Bool)
}

class WeatherViewModel {
    private(set) var name: String
    private(set) var latLon: String
    private(set) var currentWeather: CurrentWeatherViewModel?
    private(set) var forecastWeather: [ForecastWeatherModel]?
    var delegate: WeatherViewModelDelegate?
    
    
    private(set) var isUpdating: Bool = false {
        didSet {
            self.updateWeatherLoadingStatus?(isUpdating)
        }
    }
    
    public init(with name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latLon = "\(latitude),\(longitude)"
    }
    
    var temperature: String? {
        if let temp = currentWeather?.temperature {
            return "\(temp)°"
        } else {
            return "-"
        }
    }
    
    var feelsLike: String? {
        if let temp = currentWeather?.feelsLike {
            return "Feels like: \(temp)°"
        } else {
            return nil
        }
    }
    
    var didUpdateCurrentWeather: (() -> ())?
    var updateWeatherLoadingStatus: ((_ isUpdating: Bool) -> ())?
}

extension WeatherViewModel {
    func getWeather() {
        isUpdating = true
        print("\(name) is updating...")
        WeatherService().get(.weather, for: latLon, withModel: WeatherModel.self) { (result) in
            switch result {
            case .success(let payload):
                if let current = payload?.data.current.first {
                    self.currentWeather = CurrentWeatherViewModel(temperature: current.temperature,
                                                                  feelsLike: current.feelsLike)
                    self.isUpdating = false
                    self.didUpdateCurrentWeather?()
                    self.delegate?.weather(self, didFinish: true)

                }
                if let forecast = payload?.data.forecast {
                    self.forecastWeather = []
                    for day in forecast {
                        let weather = ForecastWeatherModel(date: day.date,
                                                           maxTemperature: day.maxTemperature,
                                                           minTemperature: day.minTemperature)
                        self.forecastWeather?.append(weather)
                    }
                }
            case .failure(let error):
                self.currentWeather = nil
                self.isUpdating = false
                self.didUpdateCurrentWeather?()
                self.delegate?.weather(self, didFinish: true)
                print(error)
            }
        }
    }
}
