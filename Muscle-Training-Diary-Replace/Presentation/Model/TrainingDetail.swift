//
//  TrainingDetail.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/28.
//

import Foundation

struct TrainingDetail: Equatable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let maxWeight: Double
    let previousWeight: Double
    let unit: ValueUnit
    
    var maxWeightLabel: String {
        "さいだい: \(maxWeight)\(unit.label)"
    }
    
    var previousWeightLabel: String {
        "ぜんかい: \(previousWeight)\(unit.label)"
    }
}
