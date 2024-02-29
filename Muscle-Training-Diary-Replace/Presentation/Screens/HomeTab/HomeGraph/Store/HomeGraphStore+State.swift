//
//  HomeGraphStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/29.
//

import Foundation
import ComposableArchitecture

extension HomeGraphStore {
    @ObservableState
    struct State {
        var selectedDate: String?
        var trainingDataList: [Training]
        var groupedData: Dictionary<String, Double> {
            var result: [String: Double] = [:]
            Dictionary(grouping: self.trainingDataList, by: { $0.formattedDate }).forEach { item in
                result[item.key] = item.value.map { $0.weight.doubleNumber }.reduce(0, +)
            }
            return result
        }
    }
}
