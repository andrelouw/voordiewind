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
}
