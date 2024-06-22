//
//  DataImageStore.swift
//  IconFinder
//
//  Created by Петр Постников on 21.06.2024.
//

import UIKit

final class DataImageStore {
    static var dataImageStore = DataImageStore()
    
    var images: [Int: Data?] = [:]
    var tags: [Int: [String]] = [:]
}
