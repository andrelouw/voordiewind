struct CurrentWeatherViewModel {
    var temperature: String?
    var feelsLike: String?
}

class WeatherViewModel {
    let name: String
    let latLon: String
    // TODO: move to own struct
    var currentWeather: CurrentWeatherViewModel?
    
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
    
    var didUpdateCurrentWeather: (() -> ())?
}

extension WeatherViewModel {
    func getWeather() {
        WeatherService().get(.weather, for: latLon, withModel: WeatherModel.self) { (result) in
            switch result {
            case .success(let payload):
                if let current = payload?.data.current.first {
                    self.currentWeather = CurrentWeatherViewModel(temperature: current.temperature,
                                                                  feelsLike: current.feelsLike)
                    self.didUpdateCurrentWeather?()
                }
                if let forecast = payload?.data.forecast {
//                    print("Forecast:")
//                    for day in forecast {
//                        print("\(day.date) - \(day.maxTemperature) - \(day.minTemperature)")
//                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
