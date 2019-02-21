import Foundation

class WeatherDetailViewModel {
    var name: String
    
    init(with model: WeatherViewModel) {
        name = model.name
    }
}
