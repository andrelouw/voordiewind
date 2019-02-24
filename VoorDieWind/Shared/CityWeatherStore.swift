class CityWeatherModel {
    var city: CityModel
    var weather: WeatherModel?
    
    var id: String {
        return city.identifier
    }
    
    init(city: CityModel, weather: WeatherModel? = nil) {
        self.city = city
        self.weather = weather
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
        updateWeather(for: identifier, with: payload)
    }
    
    private func handleWeatherFailure(for identifier: String, with error: WebServiceFailure?) {
        updateWeather(for: identifier, with: nil)
        print(error?.localizedDescription)
    }
    
    // TODO: Consolidate the two
    private func updateWeather(for identifier: String, with weather: WeatherModel?) {
        if let i = index(for: identifier) {
            cityWeatherList[i].weather = weather
        }
    }
}

// MARK: - Helpers
extension CityWeatherStore {
    private func index(for identifier: String) -> Int? {
        return cityWeatherList.index(where: {$0.id == identifier})
    }
}
