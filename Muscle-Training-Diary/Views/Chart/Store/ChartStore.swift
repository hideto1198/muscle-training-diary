//
//  ChartStore.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/27.
//

import Foundation
import ComposableArchitecture
import Charts

struct ChartStore: ReducerProtocol {
    struct State: Equatable {
        var trainingDatas: [TrainingData] = []
        var trainingNames: [String] = []
        var trainingNameIndex: Int = 0
        var selectedDate: String?
        var selectedItem: TrainingData?
        var selectedItems: [TrainingData]?
        var annotationPosition: AnnotationPosition = .leading
        var groupedDatas: [String: [TrainingData]] = [:]
        @BindingState var dateFrom: String = ""
        @BindingState var dateTo: String = ""
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case updateTrainingName(Int)
        case onAppear
        case onTapped(String?, isExclusive: Bool = false)
        case generate
        case set(String?)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .updateTrainingName(let index):
                state.trainingNameIndex = index
                state.selectedDate = nil
                state.selectedItems = nil
                return EffectTask(value: .generate)
            case .onAppear:
                state.trainingNames.sort()
                return EffectTask(value: .generate)
            case .binding:
                return .none
            case .onTapped(let date, isExclusive: false):
                guard state.selectedDate != date
                else {
                    state.selectedItems = nil
                    state.selectedDate = nil
                    return .none
                }
                return EffectTask(value: .set(date))
            case .onTapped(let date, isExclusive: true):
                return EffectTask(value: .set(date))
            case .set(let date):
                guard let date = date else { return .none }
                state.selectedDate = date
                state.selectedItem = state.trainingDatas.first(where: { $0.trainingDate == date })
                let currentDatas = state.trainingDatas.filter { $0.trainingName == state.trainingNames[state.trainingNameIndex] }
                state.selectedItems = currentDatas.filter { $0.trainingDate!.contains(date) }
                if Array(state.groupedDatas.keys.map { String($0) }).sorted(by: { compare($0, $1) }).filter({ compare(state.dateFrom, $0) && compare($0, state.dateTo) }).firstIndex(of: date)! < Array(state.groupedDatas.keys.map { String($0) }).sorted(by: { compare($0, $1) }).filter({ compare(state.dateFrom, $0) && compare($0, state.dateTo) }).count  / 2 {
                    state.annotationPosition = .trailing
                } else {
                    state.annotationPosition = .leading
                }
                return .none
            case .generate:
                state.groupedDatas = [:]
                let currentDatas = state.trainingDatas.filter { $0.trainingName == state.trainingNames[state.trainingNameIndex] }
                let groupedDatas = Dictionary(grouping: currentDatas) { data -> String in
                    let dates = sorted(trainingDatas: state.trainingDatas)
                    for date in dates {
                        if data.trainingDate!.contains(date) {
                            return date
                        }
                    }
                    return ""
                }
                    .sorted {
                        compare($0.key, $1.key)
                    }
                groupedDatas.forEach {
                    state.groupedDatas[$0.key] = $0.value
                }
                let sortedDateList = Array(state.groupedDatas.keys.map { String($0) }).sorted { compare($1, $0) }
                if sortedDateList.isEmpty { return .none }
                if sortedDateList.count > 7 {
                    state.dateFrom = sortedDateList[6]
                    state.dateTo = sortedDateList.first!
                } else {
                    state.dateFrom = sortedDateList.last!
                    state.dateTo = sortedDateList.first!
                }
                return .none
            }
        }
    }
}

extension ChartStore {
    private func sorted(trainingDatas: [TrainingData]) -> Array<String> {
        var result: [String] = []
        result = Array(Set(trainingDatas.map { $0.trainingDate!.components(separatedBy: " ")[0] }))
        result = result.sorted(by: { compare($0, $1) })
        return result
    }

    private func compare(_ ldate: String, _ rdate: String) -> Bool {
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            return dateFormatter
        }

        return dateFormatter.date(from: ldate)! <= dateFormatter.date(from: rdate)!
    }
}
