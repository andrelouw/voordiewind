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
    private var cities: [CitySearchViewModel]?
    
//    init(from model: CitySearchModel) {
//        for city in model.search.results {
//            self.cities.append(CitySearchViewModel(
//                name: city.name.first?["value"] ?? "",
//                region: "",
//                country: "",
//                latitude: 0.00,
//                longitude: 0.00))
//        }
//    }
    
//    func update(with model: )

}

// MARK: - Cities
extension CitySearchListViewModel {
    func updateViewModel(with model: CitySearchModel) {
        cities = []
        for city in model.search.results {
            cities?.append(CitySearchViewModel(
                name: city.name.first?["value"] ?? "",
                region: "",
                country: "",
                latitude: 0.00,
                longitude: 0.00))
        }
    }
    
    func resetCities() {
        cities = nil
    }
    
    var numberOfCities: Int {
        // include error message logic
        return cities?.count ?? 0
    }
    
    func city(for row: Int) -> CitySearchViewModel? {
        return cities?[row] ?? nil
    }
    
    func cellTitle(for row: Int) -> String {
        return cities?[row].name ?? ""
    }
    
    func cellDescription(for row: Int) -> String {
        return cities?[row].country ?? ""
    }
}
