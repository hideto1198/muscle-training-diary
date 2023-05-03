//
//  Message.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//

import Foundation

struct Message: Identifiable, Equatable {
    var id = UUID()
    var userName: String
    var messageText: String
    var timestamp: Date
    var isSelf: Bool = false
}
