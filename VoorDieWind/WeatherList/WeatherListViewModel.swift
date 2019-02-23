import Foundation



protocol WeatherListViewModelDelegate {
    func weatherList(_ viewModel: WeatherListViewModel, didFinishUpdate: Bool)
    func weatherList(_ viewModel: WeatherListViewModel, didRemove indexPath: IndexPath)
}

class WeatherListViewModel {
    var cities: [CityModel]?
    var delegate: WeatherListViewModelDelegate?
}

// MARK: - Public interface
extension WeatherListViewModel {
    
    var numberOfRows: Int {
        return cities?.count ?? 0
    }
    
    func cityWeather(for indexPath: IndexPath) -> CityWeatherModel? {
        guard let city = cities?[indexPath.row] else { return nil }
        return CityWeatherStore.shared.cityWeather(for: city.identifier)
    }
    
    func addCity(_ city: CityModel) {
        if cities == nil {
            cities = []
        }
        
        cities?.append(city)
        
        // Not sure where this should happen
        let cityWeather = CityWeatherModel(city: city, currentWeather: nil, forecastWeather: nil)
        CityWeatherStore.shared.add(cityWeather)
    }
}

extension WeatherListViewModel {
    func removeCity(at indexPath: IndexPath) {
        if let city = cities?.remove(at: indexPath.row) {
            CityWeatherStore.shared.remove(city.identifier)
            delegate?.weatherList(self, didRemove: indexPath)
        }
    }
}

// MARK: - Update all weather
extension WeatherListViewModel {
    func updateWeatherList() {
        if let cities = cities, cities.count > 0 {
            for city in cities {
                // TODO: Fix this!!!
//                city.getWeather()
            }
        } else {
            delegate?.weatherList(self, didFinishUpdate: true)
        }
    }
}

// TODO: Fix this
//extension WeatherListViewModel: WeatherViewModelDelegate {
//    func weather(_ viewModel: WeatherListCellViewModel, didFinish update: Bool) {
//        if let cities = cityWeatherList {
//            for city in cities {
//                if city.isUpdating {
//                    print("\(city.name) still busy")
//                    delegate?.weatherList(self, didFinishUpdate: false)
//                    return
//                } else {
//                    print("\(city.name) done")
//                }
//            }
//            delegate?.weatherList(self, didFinishUpdate: true)
//        }
//    }
//}
