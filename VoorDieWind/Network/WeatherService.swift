import Foundation

final class WeatherService {
    let baseURL = "http://api.worldweatheronline.com/premium/v1/%@.ashx"
    let key = "ed4a649fd5bd49b5a9425943190702"
    let format = "json"
    
    enum WeatherServicePath: String {
        case search = "search"
        case weather = "weather"
    }
}

// MARK: - City search
extension WeatherService {
//    typealias CitySearchResultType = CitySearchModel
    typealias CitySearchCompletion<ResultType> = (_ result: Result<ResultType?, WebServiceFailure>) -> Void
    
    func getCities<ResultType: Decodable>(for search: String, completion: @escaping CitySearchCompletion<ResultType>) {
        guard var url = weatherServiceURL(for: .search) else {return}
        url.appendQueryParameters(["query": search])
        let resource = Resource<ResultType>(url: url) { (data) -> ResultType? in
            return try JSONDecoder().decode(ResultType.self, from: data)
        }
        
        WebService().get(resource: resource) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

// MARK: - Weather current/forecast
extension WeatherService {
    typealias WeatherSearchCompletion<ResultType> = (_ result: Result<ResultType?, WebServiceFailure>) -> Void
    
    func getWeather<ResultType: Decodable>(for latLon: String, completion: @escaping WeatherSearchCompletion<ResultType>) {
        guard var url = weatherServiceURL(for: .weather) else {return}
        url.appendQueryParameters(["query": latLon])
        let resource = Resource<ResultType>(url: url) { (data) -> ResultType? in
            return try JSONDecoder().decode(ResultType.self, from: data)
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
