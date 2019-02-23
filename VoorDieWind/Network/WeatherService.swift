import Foundation

enum WeatherServicePath: String {
    case search = "search"
    case weather = "weather"
}

final class WeatherService {
    typealias GetCompletion<ResultType> = (_ result: Result<ResultType?, WebServiceFailure>) -> Void
    
    let baseURL = "http://api.worldweatheronline.com/premium/v1/%@.ashx"
    let key = "ed4a649fd5bd49b5a9425943190702"
    let format = "json"
}

// MARK: - Get query
extension WeatherService {
    func get<ResultType: Decodable>(_ path: WeatherServicePath, for parameters: JSON, withModel resultType: ResultType.Type, completion: @escaping GetCompletion<ResultType>) {
        guard var url = weatherServiceURL(for: path) else {return}
        url.appendQueryParameters(parameters)
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

// MARK: - Convenience
extension WeatherService {
    func get<ResultType: Decodable>(_ path: WeatherServicePath, for query: String, withModel resultType: ResultType.Type, completion: @escaping GetCompletion<ResultType>) {
        get(path, for: ["query": query], withModel: resultType, completion: completion)
    }
    
    func weather(for city: CityModel, completion: @escaping GetCompletion<WeatherModel>) {
        WeatherService().get(.weather, for: city.identifier, withModel: WeatherModel.self, completion: completion)
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
