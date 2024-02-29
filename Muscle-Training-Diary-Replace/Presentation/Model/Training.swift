//
//  Training.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/26.
//

import Foundation

struct Training: Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    var date: Date = Date()
    var name: String = ""
    var weight: Count = .init(text: "")
    var count: Count = .init(text: "")
    var setCount: Count = .init(text: "")
    var unit: ValueUnit = .kilogram
    
    var weightLabel: String {
        "\(weight.text)\(unit.label)"
    }
    
    var countLabel: String {
        if unit == .kilogram {
            return "\(count.text)回 \(setCount.text)セット"
        } else {
            return "\(count.text)km"
        }
    }
    
    var error: Bool {
        if name.isEmpty || weight.error || count.error { return true }
        if unit == .kilogram && setCount.error { return true }
        return false
    }
    
    var formattedDate: String {
        date.fullDate
    }
}

extension Training {
    var data: TrainingData {
        .init(id: self.id,
              trainingDate: self.date,
              weight: self.weight.doubleNumber,
              valueUnit: self.unit,
              count: self.count.doubleNumber,
              setCount: self.setCount.intNumber,
              trainingName: self.name,
              memo: "")
    }
    
    static var fake: Self {
        .init(date: Date(), name: "ベンチプレス", weight: .init(text: "100.0"), count: .init(text: "10"), setCount: .init(text: "3"), unit: .kilogram)
    }
    
    static var feke2: Self {
        .init(date: Date(), name: "インクラインベンチプレス", weight: .init(text: "100.0"), count: .init(text: "10"), setCount: .init(text: "3"), unit: .kilogram)
    }
}
