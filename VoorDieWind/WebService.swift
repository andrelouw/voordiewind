//
//  WeatherService.swift
//  VoorDieWind
//
//  Created by Andre Louw on 2019/02/14.
//  Copyright © 2019 Andre Louw. All rights reserved.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
    // TODO: Maybe include something for error handling? 
}

final class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            // TODO: handle error etc
            print(data)
            if let data = data {
                DispatchQueue.main.async {
                       completion(resource.parse(data))
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
