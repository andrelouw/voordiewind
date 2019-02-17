import Foundation

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
