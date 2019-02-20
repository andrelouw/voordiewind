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
    case undefined = 000
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
            return "The service call failed with error code: \(code.rawValue)"
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
        var request = URLRequest(url: resource.url,
                                 cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 5.0)
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
