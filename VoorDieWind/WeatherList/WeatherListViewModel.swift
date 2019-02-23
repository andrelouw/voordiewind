import Foundation



protocol WeatherListViewModelDelegate {
//    func weatherList(_ viewModel: WeatherListViewModel, didFinishUpdate: Bool)
    func weatherList(_ viewModel: WeatherListViewModel, didRemove indexPath: IndexPath)
}

class WeatherListViewModel {
    var cities: [CityWeatherModel] {
        return CityWeatherStore.shared.cityWeatherList
    }
    var delegate: WeatherListViewModelDelegate?
}

// MARK: - Public interface
extension WeatherListViewModel {
    
    var numberOfRows: Int {
        return cities.count
    }
    
    func cityWeather(for indexPath: IndexPath) -> CityWeatherModel? {
        return cities[safe: indexPath.row]
    }
    
    func addCity(_ city: CityModel) {
        // Not sure where this should happen
        let cityWeather = CityWeatherModel(city: city, currentWeather: nil, forecastWeather: nil)
        CityWeatherStore.shared.add(cityWeather)
    }
}

extension WeatherListViewModel {
    func removeCity(at indexPath: IndexPath) {
        guard let city = cities[safe: indexPath.row],
            let _ = CityWeatherStore.shared.remove(city.id) else { return }
        delegate?.weatherList(self, didRemove: indexPath)
    }
}

// MARK: - Update all weather
extension WeatherListViewModel {
    @objc func updateWeatherList(_ notification: Notification) {
//        if let cities = cities, cities.count > 0 {
//            for city in cities {
                // TODO: Fix this!!!
//                city.getWeather()
//            }
//        } else {
//            delegate?.weatherList(self, didFinishUpdate: true)
//        }
        print(notification.object)
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

extension WeatherListViewModel {
    
}

