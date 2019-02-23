class CityWeatherModel {
    var city: CityModel
    // TODO: consolidate the below into one
    var currentWeather: CurrentWeatherModel?
    var forecastWeather: [ForecastWeatherModel]?
    
    var id: String {
        return city.identifier
    }
    
    init(city: CityModel, currentWeather: CurrentWeatherModel? = nil, forecastWeather: [ForecastWeatherModel]? = nil) {
        self.city = city
        self.currentWeather = currentWeather
        self.forecastWeather = forecastWeather
    }
}

class CityWeatherStore {
    private(set) var cityWeatherList: [CityWeatherModel]
    typealias UpdateWeatherCompletion = (_ cityWeather: CityWeatherModel?) -> Void
    
    static let shared = CityWeatherStore()
    
    init() {
        cityWeatherList = []
    }
}

// MARK: - Public api
extension CityWeatherStore {
    
    func add(_ cityWeather: CityWeatherModel) {
        cityWeatherList.append(cityWeather)
    }
    
    func remove(_ identifier: String) -> CityWeatherModel? {
        guard let index = index(for: identifier) else {return nil}
        return cityWeatherList.remove(at: index)
    }
    
    var numberOfCities: Int {
        return cityWeatherList.count
    }
    
    func cityWeather(for identifier: String) -> CityWeatherModel? {
        return cityWeatherList.filter {$0.id == identifier}.first ?? nil
    }
    
    func contains(_ identifier: String) -> Bool {
        return cityWeatherList.contains { $0.id == identifier}
    }
}

// MARK: - Update Weather
extension CityWeatherStore {
    func updateWeather(for identifier: String, completion: UpdateWeatherCompletion? ) {
        print("\(String(describing: cityWeather(for: identifier)?.city.name)) is updating...")
        WeatherService().get(.weather, for: identifier, withModel: WeatherModel.self) { [weak self] (result) in
            switch result {
            case .success(let payload):
                self?.handleWeatherSuccess(for: identifier, with: payload)
            case .failure(let error):
                self?.handleWeatherFailure(for: identifier, with: error)
            }
            completion?(self?.cityWeather(for: identifier))
        }
    }
    
    private func handleWeatherSuccess(for identifier: String, with payload: WeatherModel?) {
        guard let payload = payload else { return }
        updateCurrentWeather(for: identifier, with: payload.current)
        updateForecastWeather(for: identifier, with: payload.forecast)
    }
    
    private func handleWeatherFailure(for identifier: String, with error: WebServiceFailure?) {
        updateCurrentWeather(for: identifier, with: nil)
        updateForecastWeather(for: identifier, with: nil)
        print(error?.localizedDescription)
    }
    
    // TODO: Consolidate the two
    private func updateCurrentWeather(for identifier: String, with weather: CurrentWeatherModel?) {
        if let i = index(for: identifier) {
            cityWeatherList[i].currentWeather = weather
        }
    }
    
    private func updateForecastWeather(for identifier: String, with forecast: [ForecastWeatherModel]?) {
        if let i = index(for: identifier) {
            cityWeatherList[i].forecastWeather = forecast
        }
    }
}

// MARK: - Helpers
extension CityWeatherStore {
    private func index(for identifier: String) -> Int? {
        return cityWeatherList.index(where: {$0.id == identifier})
    }
}
