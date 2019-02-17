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
