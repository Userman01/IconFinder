//
//  NetworkProvider.swift
//  UnsplashApp
//
//  Created by Петр Постников on 29.03.2024.
//

import Foundation

protocol NetworkProviderProtocol {
    func getRequest(searchText: String, completion: @escaping (ResultsModel?) -> ())
}

final class NetworkProvider: NetworkProviderProtocol {
    
    var networkService = NetworkService()
    
    func getRequest(searchText: String, completion: @escaping (ResultsModel?) -> ()) {
        if let result = DataResultStore.dataResultStore.results[searchText] {
            completion(result)
        } else {
            networkService.request(searchText: searchText) { [weak self] data, error in
                if let error {
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    let decode = self?.decodeJSON(type: ResultsModel.self, data: data)
                    DataResultStore.dataResultStore.results[searchText] = decode
                    completion(decode)
                }
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        guard let data else { return nil }
        let decoder = JSONDecoder()
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print(error)
            return nil
        }
    }
}
