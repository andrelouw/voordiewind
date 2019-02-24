import UIKit
import Foundation

protocol WeatherListViewModelDelegate {
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
        let cityWeather = CityWeatherModel(city: city, weather: nil)
        CityWeatherStore.shared.add(cityWeather)
    }
    
    func removeCity(at indexPath: IndexPath) {
        guard let city = cities[safe: indexPath.row],
            let _ = CityWeatherStore.shared.remove(city.id) else { return }
        delegate?.weatherList(self, didRemove: indexPath)
    }
}

// MARK: - Strings
extension WeatherListViewModel {
    var title: String {
        return  "Voor die wind"
    }
    
    var noDataTitle: String {
        return "Geen stede in jou voer?"
    }
    
    var noDataMessage: String {
        return "Wil jy nie dalk soek vir jou gunsteling stad nie?"
    }
    
    var noDataImage: UIImage {
        return UIImage(named: "umbrella") ?? UIImage()
    }
    
    var noDataButtonTitle: String {
        return "Soek 'n stad"
    }
    
    var deleteButtonTitle: String {
        return "Verwyder"
    }
    
    var deleteButtonColor: UIColor {
        return .red
    }
    
    var deleteAlertTitle: String {
         return  "Is jy seker?"
    }
    
    var deleteAlertMessage: String {
        return  "Het jy vrede gemaak, die stad gaan nou jou voer verlaat"
    }
    
    var deleteAlertConfirmation: String {
        return  "Gaan voort"
    }
    
    var deleteAlertCancel: String {
        return  "Gaan terug"
    }
}
