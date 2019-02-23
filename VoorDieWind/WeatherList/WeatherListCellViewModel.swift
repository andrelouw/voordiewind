protocol WeatherViewModelDelegate {
    func weather(_ viewModel: WeatherListCellViewModel, didFinish update: Bool)
}

class WeatherListCellViewModel {
    private(set) var name: String
    private(set) var latLon: String
    private(set) var currentWeather: CurrentWeatherModel?
    private(set) var forecastWeather: [ForecastWeatherModel]?
    var delegate: WeatherViewModelDelegate?
    
    
    private(set) var isUpdating: Bool = false {
        didSet {
            self.updateWeatherLoadingStatus?(isUpdating)
        }
    }
    
    public init(with name: String, latitude: Double, longitude: Double) {
        self.name = name
        // TODO: create key utility from this!!!
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
        if let temp = currentWeather?.feelsLikeTemperature {
            return "Feels like: \(temp)°"
        } else {
            return nil
        }
    }
    
    var didUpdateCurrentWeather: (() -> ())?
    var updateWeatherLoadingStatus: ((_ isUpdating: Bool) -> ())?
}

extension WeatherListCellViewModel {
    func getWeather() {
        isUpdating = true
        print("\(name) is updating...")
        WeatherService().get(.weather, for: latLon, withModel: WeatherModel.self) { [weak self] (result) in
            switch result {
            case .success(let payload):
                self?.handleSuccess(with: payload)
            case .failure(let error):
               self?.handleFailure(with: error)
            }
        }
    }

    private func handleSuccess(with payload: WeatherModel?) {
        guard let current = payload?.data.current.first,
            let forecast = payload?.data.forecast
        else {
            // TODO: What do we do here?
            return
        }
        self.currentWeather = current
        
        self.forecastWeather = []
        for day in forecast {
            let weather = ForecastWeatherModel(date: day.date,
                                               maxTemperature: day.maxTemperature,
                                               minTemperature: day.minTemperature)
            self.forecastWeather?.append(weather)
        }
        
        self.isUpdating = false
        self.didUpdateCurrentWeather?()
        self.delegate?.weather(self, didFinish: true)
    }

    private func handleFailure(with error: WebServiceFailure?) {
        self.currentWeather = nil
        self.forecastWeather = nil
        
        self.isUpdating = false
        self.didUpdateCurrentWeather?()
        self.delegate?.weather(self, didFinish: true)
        print(error)
    }
}
