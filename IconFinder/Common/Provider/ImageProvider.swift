//
//  ImageProvider.swift
//  UnsplashApp
//
//  Created by Петр Постников on 30.03.2024.
//

import UIKit

struct ImageProvider {
    
    static func fetchImage(from url: URL, completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = getHeasder()
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, responce, error in
            completion(data, error)
        }.resume()
        
        func getHeasder() -> [String: String] {
            var headers: [String: String] = [:]
            headers["Authorization"] = APIkey.key
            headers["accept"] = "application/json"
            return headers
        }
    }
}
