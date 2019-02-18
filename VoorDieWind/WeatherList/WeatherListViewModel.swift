class WeatherListViewModel {
    private var cities: [WeatherViewModel]?
}

// MARK: - Public interface
extension WeatherListViewModel {
    var numberOfRows: Int {
        if let numberOfCities = cities?.count {
            return numberOfCities
        }
        return 0
    }
    
    func city(for row: Int) -> WeatherViewModel? {
        if let city = cities?[row] {
            return city
        }
        return nil
    }
    
    func weatherViewModel(for row: Int) -> WeatherViewModel? {
        if let viewModel = cities?[row] {
            return viewModel
        }
        return nil
    }
    
    func addCity(_ city: CitySearchViewModel?) {
        guard let city = city else { return }
        if cities == nil {
            cities = []
        }
        
        let newCity = WeatherViewModel(with: city.name, latitude: Double(city.latitude), longitude: Double(city.longitude))
        cities?.append(newCity)

    }
}

extension WeatherListViewModel {
    func updateWeatherList() {
        if let cities = cities {
            for city in cities {
                city.getWeather()
            }
        }
        
    }
}
