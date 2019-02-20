import Foundation

protocol WeatherListViewModelDelegate {
    func weatherList(_ viewModel: WeatherListViewModel, didFinishUpdate: Bool)
}

class WeatherListViewModel {
    private var cities: [WeatherViewModel]?
    var delegate: WeatherListViewModelDelegate?
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
        newCity.delegate = self
        cities?.append(newCity)
        newCity.getWeather()
    }
    
    func contains(_ city: CitySearchViewModel) -> Bool {
        return cities?.contains { $0.latLon == "\(city.latitude),\(city.longitude)"} ?? false
    }
}

// MARK: - Update all weather
extension WeatherListViewModel {
    func updateWeatherList() {
        if let cities = cities {
            for city in cities {
                city.getWeather()
            }
        } else {
            delegate?.weatherList(self, didFinishUpdate: true)
        }
    }
}

extension WeatherListViewModel: WeatherViewModelDelegate {
    func weather(_ viewModel: WeatherViewModel, didFinish update: Bool) {
        if let cities = cities {
            for city in cities {
                if city.isUpdating {
                    print("\(city.name) still busy")
                    delegate?.weatherList(self, didFinishUpdate: false)
                    return
                } else {
                    print("\(city.name) done")
                }
            }
            delegate?.weatherList(self, didFinishUpdate: true)
        }
    }
}
