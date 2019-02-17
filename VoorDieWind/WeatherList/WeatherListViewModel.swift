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
    
    func cityName(for row: Int) -> String? {
        if let name = cities?[row].name {
            return name
        }
        return nil
    }
    
    func cellTemperature(for row: Int) -> String? {
       if let temperature = cities?[row].temperature {
            return temperature
        }
        return nil
    }
    
    func addCity(_ city: CitySearchViewModel?) {
        guard let city = city else { return }
        if cities == nil {
            cities = []
        }
        
//        "30°" // shift option 8 to get degrees
        let newCity = WeatherViewModel(name: city.name, temperature: "50°")
        cities?.append(newCity)
    }
}

