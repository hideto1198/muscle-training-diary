//
//  TrainingData.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import Foundation
import Charts

struct TrainingData: Equatable, Identifiable, Hashable {

    var id: String = UUID().uuidString
    var recordDate: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: Date())
    }

    var value: Double {
        if valueUnit == .minutes {
            return Double(count)
        } else {
            return (weight == 0.0 ? 1 : weight) * Double(count == 0 ? 1 : count) *  Double(setCount == 0 ? 1 : setCount)
        }
    }

    var trainingDate: String?
    var trainingName: String
    var weight: Double
    var valueUnit: ValueUnit
    var count: Double
    var setCount: Int
    var memo: String

    var toDict: [String: Any] {
        return [
            "trainingDate": trainingDate ?? "",
            "trainingName": trainingName,
            "weight": weight,
            "valueUnit": valueUnit.label,
            "count": count,
            "setCount": setCount,
            "memo": memo
        ]
    }

    static func fromDict(dict: [String: Any]) -> Self {
        return TrainingData(
            trainingDate: dict["trainingDate"] as? String,
            trainingName: dict["trainingName"]! as! String,
            weight: dict["weight"]! as! Double,
            valueUnit: ValueUnit.type(unitString: dict["valueUnit"] as! String),
            count: dict["count"]! as! Double,
            setCount: dict["setCount"]! as! Int,
            memo: dict["memo"]! as! String)
    }
}
