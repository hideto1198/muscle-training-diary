//
//  UserDefaults+Extension.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/04/04.
//

import Foundation

extension UserDefaults {
  func setEncoded<T: Encodable>(_ value: T, forKey key: String) {
    guard let data = try? JSONEncoder().encode(value) else {
       fatalError("Can not Encode to JSON.")
    }

    set(data, forKey: key)
  }

  func decodedObject<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
    guard let data = data(forKey: key) else {
      return nil
    }

    return try? JSONDecoder().decode(type, from: data)
  }
}
