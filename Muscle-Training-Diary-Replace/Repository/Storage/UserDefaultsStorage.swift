//
//  UserDefaults.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation

enum UserDefaultsStorage {
    private static var store: UserDefaults { .standard }
    
    static func set(trainingName: String) {
        var trainingNames = getTraingNames()
        if !trainingNames.contains(trainingName) {
            trainingNames.append(trainingName)
        }
        trainingNames.sort(by: { $0 < $1 })
        store.set(trainingNames, forKey: Keys.trainingNames.rawValue)
    }
    
    static func getTraingNames() -> [String] {
        guard store.contains(forKey: Keys.trainingNames.rawValue) else { return [] }
        return store.stringArray(forKey: Keys.trainingNames.rawValue)!
    }
    
    static func set(userId: String) {
        store.set(userId, forKey: Keys.userId.rawValue)
    }
    
    static func getUserId() -> String? {
        guard store.contains(forKey: Keys.userId.rawValue) else { return nil }
        return store.string(forKey: Keys.userId.rawValue)
    }

    static func set(sort: Sort) {
        store.set(sort.rawValue, forKey: Keys.sort.rawValue)
    }
    
    static func getSort() -> Sort {
        guard store.contains(forKey: Keys.sort.rawValue) else { return .alphabet }
        return Sort(rawValue: store.integer(forKey: Keys.sort.rawValue))!
    }
}

extension UserDefaultsStorage {
    enum Keys: String {
        case userId
        case trainingNames
        case sort
    }
}

extension UserDefaults {
    func contains(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
