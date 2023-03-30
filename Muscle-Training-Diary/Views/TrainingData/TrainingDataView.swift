//
//  TrainingDataView.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/26.
//

import SwiftUI
import ComposableArchitecture

struct TrainingDataView: View {
    let store: StoreOf<TrainingDataStore>
    let trainingData: String

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                List {
                    ForEach(viewStore.trainingDatas.filter { $0.trainingDate!.contains(trainingData) }) { data in
                        Button(
                            action: {
                                viewStore.send(.onEdit(data), animation: .easeInOut)
                            },
                            label: {
                                VStack(alignment: .leading) {
                                    Text(data.trainingName)
                                        .font(.system(size: 20, weight: .black))
                                    HStack {
                                        Text(String(format: "%.2f", data.weight))
                                        Text(data.valueUnit.label)
                                    }
                                    .font(.system(size: 20, weight: .black))
                                    setCountView(data: data)
                                    memoView(memo: data.memo)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        )
                    }
                    .onDelete { offset in
                        if let index = offset.first {
                            let data = viewStore.trainingDatas.filter { $0.trainingDate!.contains(trainingData) }[index]
                            viewStore.send(.deleteTrainingData(data))
                        }
                    }
                }
                alert
            }
        }
    }

    private func setCountView(data: TrainingData) -> some View {
        Group {
            if data.count == 0 {
                EmptyView()
            } else {
                Text("\(data.count) × \(data.setCount)セット")
                    .font(.system(size: 20, weight: .black))
            }
        }
    }

    private func memoView(memo: String) -> some View {
        Group {
            if memo == "" {
                EmptyView()
            } else {
                Text("メモ")
                    .font(.system(size: 16, weight: .bold))
                Text(memo)
                    .font(.system(size: 20, weight: .black))
                    .padding(.leading)
            }
        }
    }

    private var alert: some View {
        IfLetStore(store.scope(state: \.dataInputState,
                               action: TrainingDataStore.Action.dataInputAction),
                   then: { store in
                        DataInputView(store: store)
                    }
        )
    }
}

struct TrainingDataView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingDataView(store: Store(initialState: TrainingDataStore.State(),
                                      reducer: TrainingDataStore()),
                         trainingData: "")
    }
}
