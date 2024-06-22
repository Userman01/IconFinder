//
//  FirstViewModel.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import UIKit
import Combine

final class MainViewModel {
    
    private let networkProvider: NetworkProviderProtocol

    var cancellables = Set<AnyCancellable>()
    var searchText: String = ""
    
    @Published var result: ResultsModel?
    @Published var isSaved: Bool = false
    var id: Int?
    
    init(networkProvider: NetworkProviderProtocol = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func getRequest(searchText: String) {
        self.searchText = searchText
        
        networkProvider.getRequest(searchText: self.searchText) {[weak self] result in
            self?.result = result
        }
    }
    
    func saveInfo(id: Int) {
        self.id = id
        isSaved = DataStoreService.dataStoreService.saveData(id: id)
    }
    
    func getIsSave(id: Int) -> Bool {
        return DataStoreService.dataStoreService.isSavedData(id: id)
    }
}
