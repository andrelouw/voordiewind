struct CityWeatherModel {
    let city: CityModel
    let currentWeather: CurrentWeatherModel?
    let forecastWeather: ForecastWeatherModel?
    
    var id: String {
        return city.identifier
    }
}

class CityWeatherStore {
    private var cityWeatherList: [CityWeatherModel]
    
    static let shared = CityWeatherStore()
    
    init() {
        cityWeatherList = []
    }
    
    func add(_ cityWeather: CityWeatherModel) {
        cityWeatherList.append(cityWeather)
    }
    
    func remove(_ identifier: String) {
        guard let index = cityWeatherList.index(where: {$0.id == identifier}) else {return}
        cityWeatherList.remove(at: index)
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
