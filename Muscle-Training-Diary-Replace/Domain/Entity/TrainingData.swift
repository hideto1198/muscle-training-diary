//
//  TrainingData.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation

struct TrainingData: Equatable, Codable {
    var id: UUID
    var trainingDate: Date
    var weight: Double
    var valueUnit: ValueUnit
    var count: Double
    var setCount: Int
    var trainingName: String
    var memo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case trainingDate = "training_date"
        case weight
        case valueUnit = "value_unit"
        case count
        case setCount = "set_count"
        case trainingName = "training_name"
        case memo
    }
    
    init(id: UUID = UUID(), trainingDate: Date, weight: Double, valueUnit: ValueUnit, count: Double, setCount: Int, trainingName: String, memo: String) {
        self.id = id
        self.trainingDate = trainingDate
        self.weight = weight
        self.valueUnit = valueUnit
        self.count = count
        self.setCount = setCount
        self.trainingName = trainingName
        self.memo = memo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try UUID(uuidString: container.decode(String.self, forKey: .id)) ?? UUID()
        self.trainingDate = try container.decode(Date.self, forKey: .trainingDate)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.valueUnit = try container.decode(ValueUnit.self, forKey: .valueUnit)
        self.count = try container.decode(Double.self, forKey: .count)
        self.setCount = try container.decode(Int.self, forKey: .setCount)
        self.trainingName = try container.decode(String.self, forKey: .trainingName)
        self.memo = try container.decode(String.self, forKey: .memo)
    }
}

extension TrainingData {
    func convert() -> Training {
        .init(id: self.id, date: self.trainingDate, name: self.trainingName, weight: .init(text: "\(self.weight)"), count: .init(text: "\(self.count)"), setCount: .init(text: "\(self.setCount)"), unit: self.valueUnit)
    }
    
    static var fake: Self {
        .init(trainingDate: Date(),
              weight: 10,
              valueUnit: .kilogram,
              count: 10,
              setCount: 3, 
              trainingName: "ベンチプレス",
              memo: "")
    }
}
