import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) throws -> T?
}
// TODO: Cleanup
enum HTTPErrorCode: Int {
    case unAuthorized = 401
    case notFound = 404
    case serverError = 500
    case undefined
}

enum WebServiceFailure: Error {
    case customError(error: String)
    case serviceCallFailed(code: HTTPErrorCode)
    case parsingFailed(error: String)
    
    var message: String {
        switch self {
        case .customError(let error):
            return "An unexpected error occurred: \(error)"
        case .serviceCallFailed(let code):
            return "The service call failed with error code: \(code)"
        case .parsingFailed(let error):
            return "Unable to parse response, with error: \(error)"
        }
    }
}

final class WebService {
    typealias WebServiceResult<Payload> = Result<Payload?, WebServiceFailure>
    typealias WebServiceCompletion<Payload> = (_ result: WebServiceResult<Payload>) -> Void
    
    func get<Payload>(resource: Resource<Payload>, completion: @escaping WebServiceCompletion<Payload>) {
        URLSession.shared.invalidateAndCancel()
        var request = URLRequest(url: resource.url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let err: WebServiceFailure = .customError(error: error.localizedDescription)
                completion(.failure(err))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode != 200 {
                let err: WebServiceFailure = .serviceCallFailed(code: HTTPErrorCode(rawValue: statusCode) ?? .undefined)
                completion(.failure(err))
                return
            }
            
            if let knownData = data, !knownData.isEmpty {
                do {
                    let payload = try resource.parse(knownData)
                    completion(.success(payload: payload))
                } catch {
                    let err: WebServiceFailure = .parsingFailed(error: error.localizedDescription)
                    completion(.failure(err))
                }
            } else {
                completion(.success(payload: nil))
            }
            }.resume()
    }
}

enum Result<T, U>  where U: Error {
    case success(payload: T)
    case failure(U?)
}

final class WeatherService {
    
    enum WeatherServicePath: String {
        case search = "search"
        case forecast = "weather"
    }
    
    typealias CitySearchResultType = CitySearchModel
    typealias CitySearchCompletion = (_ result: Result<CitySearchResultType?, WebServiceFailure>) -> Void
    
    let baseURL = "http://api.worldweatheronline.com/premium/v1/%@.ashx"
    let key = "ed4a649fd5bd49b5a9425943190702"
    let format = "json"
    
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


// Moved to extions files
extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    mutating func addQueryParameters(_ parametersDictionary : Dictionary<String, String>) {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        self = URL(string: URLString)!
    }
    
    mutating func appendQueryParameters(_ parametersDictionary : Dictionary<String, String>) {
        let URLString : String = String(format: "%@&%@", self.absoluteString, parametersDictionary.queryParameters)
        self = URL(string: URLString)!
    }
}

extension Dictionary {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}
