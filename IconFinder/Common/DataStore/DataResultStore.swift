//
//  DataResultStore.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import Foundation

final class DataResultStore {
    static var dataResultStore = DataResultStore()
    
    var results: [String: ResultsModel] = [:]
}
