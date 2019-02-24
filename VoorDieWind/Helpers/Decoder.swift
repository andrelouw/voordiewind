import Foundation

class WeatherServiceDecoder {
    static func decodeJSONToString<Key>(for values: KeyedDecodingContainer<Key>, key: Key) throws -> String {
        guard let string = try values.decode([JSON].self, forKey: key).first?["value"] else {
            throw DecodingError.dataCorrupted(.init(codingPath: [key], debugDescription: "Expecting string representation of [JSON]"))
        }
        return string
    }
    
    static func decodeStringToDouble<Key>(for values: KeyedDecodingContainer<Key>, key: Key) throws -> Double {
        guard let double = try Double(values.decode(String.self, forKey: key)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [key], debugDescription: "Expecting double representation of string"))
        }
        return double
    }
    
    static func decodeStringToInt<Key>(for values: KeyedDecodingContainer<Key>, key: Key) throws -> Int {
        guard let int = try Int(values.decode(String.self, forKey: key)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [key], debugDescription: "Expecting int representation of string"))
        }
        return int
    }
    
    static func decodeStringToDate<Key>(for values: KeyedDecodingContainer<Key>, key: Key) throws -> Date {
        guard let date = try WeatherDate().date(from: values.decode(String.self, forKey: key))  else {
            throw DecodingError.dataCorrupted(.init(codingPath: [key], debugDescription: "Expecting date representation of string"))
        }
        return date
    }
}
