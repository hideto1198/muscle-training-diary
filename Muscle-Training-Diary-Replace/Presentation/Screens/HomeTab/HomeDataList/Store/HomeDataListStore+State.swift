//
//  HomeDataListStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import SwiftUI
import Foundation
import ComposableArchitecture

extension HomeDataListStore {
    @ObservableState
    struct State {
        var sort: Sort = .alphabet
        var loadStatus: LoadStatus = .none
        var homeDataList: IdentifiedArrayOf<HomeDataStore.State> = []
        var trainingDataList: [Training] = []
        var trainingDetailList: [TrainingDetail] {
            @Dependency(\.storageClient) var storageClient
            let items = storageClient.getTrainingNames()
            return items.compactMap { trainingName -> TrainingDetail? in
                guard let maxData = trainingDataList.filter({ $0.name == trainingName }).max(by: { $0.weight.doubleNumber < $1.weight.doubleNumber }),
                      let previousData = trainingDataList.filter({ $0.name == trainingName }).first
                else {
                    return nil
                }
                return TrainingDetail(name: trainingName,
                                      maxWeight: maxData.weight.doubleNumber,
                                      previousWeight: previousData.weight.doubleNumber,
                                      previousDate: previousData.date,
                                      unit: maxData.unit,
                                      count: trainingDataList.filter({ $0.name == trainingName }).count)
            }
            .sorted(by: {
                switch sort {
                case .alphabet:
                    return $0.name < $1.name
                case .count:
                    return $0.count > $1.count
                case .rate:
                    return $0.previousDate > $1.previousDate
                }
            })
        }
        @Presents var alert: AlertState<Action.Alert>?
        var detailStatus: DetailStatus = .open
        
        enum DetailStatus {
            case open
            case close
            
            var image: Image {
                switch self {
                case .open:
                    return Asset.usagiOpen.swiftUIImage
                case .close:
                    return Asset.usagiClose.swiftUIImage
                }
            }
        }
    }
}
