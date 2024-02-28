//
//  StorageRepository.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation

enum StorageRepository {
    static func set(trainingName: String) {
        UserDefaultsStorage.set(trainingName: trainingName)
    }
    
    static func getTraingNames() -> [String] {
        UserDefaultsStorage.getTraingNames()
    }
    
    static func set(userId: String) {
        UserDefaultsStorage.set(userId: userId)
    }
    
    static func getUserId() -> String? {
        UserDefaultsStorage.getUserId()
    }
}
