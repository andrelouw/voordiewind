import Foundation

final class WeatherService {
    let baseURL = "http://api.worldweatheronline.com/premium/v1/%@.ashx"
    let key = "ed4a649fd5bd49b5a9425943190702"
    let format = "json"
    
    enum WeatherServicePath: String {
        case search = "search"
        case forecast = "weather"
    }
}

// MARK: - City search
extension WeatherService {
    typealias CitySearchResultType = CitySearchModel
    typealias CitySearchCompletion = (_ result: Result<CitySearchResultType?, WebServiceFailure>) -> Void
    
    func getCities(for search: String, completion: @escaping CitySearchCompletion) {
        guard var url = weatherServiceURL(for: .search) else {return}
        url.appendQueryParameters(["query": search])
        let resource = Resource<CitySearchResultType>(url: url) { (data) -> CitySearchModel? in
            return try JSONDecoder().decode(CitySearchModel.self, from: data)
        }
        
        WebService().get(resource: resource) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

// MARK: - Helpers
extension WeatherService {
    private func weatherServiceURL(for path: WeatherServicePath) -> URL? {
        let pathString = path.rawValue
        let urlString = String(format: baseURL, pathString)
        guard var url = URL(string: urlString) else { return nil }
        let parameters = [
            "key": key,
            "format": format,
            ]
        url.addQueryParameters(parameters)
        return url
    }
}
