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
        trainingNames.append(trainingName)
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
}

extension UserDefaultsStorage {
    enum Keys: String {
        case userId
        case trainingNames
    }
}

extension UserDefaults {
    func contains(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
