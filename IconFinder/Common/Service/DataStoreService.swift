//
//  DataStore.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import UIKit

final class DataStoreService {
    
    static var dataStoreService = DataStoreService()
    
    private let defaults = UserDefaults.standard
    private var keys: [Int] = []
    private let countFavorite: Int = 6
    
    func saveData(id: Int) -> Bool {
        if isSavedData(id: id) {
            deleteDataID(id: id)
            deleteKey(id: id)
            deleteTags(id: id)
            return isSavedData(id: id)
        } else {
            if let data = DataImageStore.dataImageStore.images[id] {
                let encoder = JSONEncoder()
                if let encode = try? encoder.encode(data) {
                    defaults.set(encode, forKey: String(id))
                    saveKeys(id: id)
                    saveTags(id: id)
                    limitFavorites()
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    func isSavedData(id: Int) -> Bool {
        if let object = defaults.object(forKey: String(id)) as? Data {
            print(object)
            return true
        } else {
            return false
        }
    }
    
    func getDatas() -> [DataModel] {
        var result: [DataModel] = []
        keys = getKeys()
        keys.forEach {
            guard let data = getData(id: $0) else { return }
            let tags = getTags(id: $0)
            result.append(DataModel(imageData: data, tags: tags, id: $0))
        }
        return result
    }
    
    func deleteData(id: Int) -> [DataModel] {
        var result: [DataModel] = []
        deleteKey(id: id)
        deleteTags(id: id)
        deleteDataID(id: id)
        keys = getKeys()
        keys.forEach {
            guard let data = getData(id: $0) else { return }
            let tags = getTags(id: $0)
            result.append(DataModel(imageData: data, tags: tags, id: $0))
        }
        return result
    }
    
    private func limitFavorites() {
        keys = getKeys()
        if countFavorite <= keys.count {
            if let id = keys.first {
                deleteDataID(id: id)
                deleteKey(id: id)
                deleteTags(id: id)
            }
        }
    }
    
    private func deleteDataID(id: Int) {
        if isSavedData(id: id) {
            defaults.removeObject(forKey: String(id))
        }
    }
    
    private func getData(id: Int) -> Data? {
        var data: Data? = nil
        if let object = defaults.object(forKey: String(id)) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(Data.self, from: object) {
                data = object
            }
        }
        return data
    }
    
    private func getTags(id: Int) -> [String] {
        let idString = String(id) + "tags"
        var tags: [String] = []
        if let object = defaults.object(forKey: idString) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode([String].self, from: object) {
                tags = object
            }
        }
        return tags
    }
    
    private func saveKeys(id: Int) {
        keys = getKeys()
        keys.append(id)
        let encoder = JSONEncoder()
        if let encode = try? encoder.encode(keys) {
            defaults.set(encode, forKey: "keys")
        }
    }
    
    private func deleteKey(id: Int) {
        keys = getKeys()
        keys = keys.filter {
            $0 != id
        }
        let encoder = JSONEncoder()
        if let encode = try? encoder.encode(keys) {
            defaults.set(encode, forKey: "keys")
        }
    }
    
    private func getKeys() -> [Int] {
        var keys: [Int] = []
        if let object = defaults.object(forKey: "keys") as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode([Int].self, from: object) {
                keys = object
            }
        }
        return keys
    }
    
    private func saveTags(id: Int) {
        let idString = String(id) + "tags"
        if let data = DataImageStore.dataImageStore.tags[id] {
            let encoder = JSONEncoder()
            if let encode = try? encoder.encode(data) {
                defaults.set(encode, forKey: String(idString))
            }
        }
    }
    
    private func deleteTags(id: Int) {
        let idString = String(id) + "tags"
        if isSavedTags(id: idString) {
            defaults.removeObject(forKey: idString)
        }
    }
    
    private func isSavedTags(id: String) -> Bool {
        if let object = defaults.object(forKey: id) as? Data {
            print(object)
            return true
        } else {
            return false
        }
    }
}
