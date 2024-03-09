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
        var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        var endDate: Date = Date()
        var selectedDate: String?
        var trainingDataList: [Training]
        var filteredDataList: [Training] {
            trainingDataList.filter { $0.formattedDate == selectedDate }
        }
        var groupedData: Dictionary<String, Double> {
            var result: [String: Double] = [:]
            Dictionary(grouping: self.trainingDataList.filter {
                if startDate == endDate {
                    return $0.date == startDate
                }
                if startDate > endDate {
                    if case endDate...startDate = $0.date { return true } else { return false }
                } else {
                    if case startDate...endDate = $0.date { return true } else { return false }
                }
            }, by: { $0.formattedDate }).forEach { item in
                result[item.key] = item.value.map { $0.weight.doubleNumber }.reduce(0, +)
            }
            return result
        }
    }
}
