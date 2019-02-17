import Foundation

struct CitySearchViewModel {
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    var key: String {
        return "\(latitude),\(longitude)"
    }
}

class CitySearchListViewModel {
    var cities = [CitySearchViewModel]()
    
    init(from model: CitySearchModel) {
        for city in model.search.results {
            self.cities.append(CitySearchViewModel(
                name: city.name.first?["value"] ?? "",
                region: "",
                country: "",
                latitude: 0.00,
                longitude: 0.00))
        }
    }
    
    
}
