//
//  DateEntity.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/10.
//

import Foundation

public struct DateEntity: Equatable, Hashable, Identifiable {
    public let id: UUID = UUID()
    public let date: String
    public let week: Week
}
