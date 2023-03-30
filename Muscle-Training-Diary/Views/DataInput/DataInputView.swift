//
//  AlertView.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/26.
//

import SwiftUI
import ComposableArchitecture

struct DataInputView: View {
    let store: StoreOf<DataInputStore>

    var body: some View {
        ZStack {
            VStack {
                Text("記録の入力")
                    .padding()
                alertBody
                alertBottom
            }
            .frame(maxWidth: .infinity)
            .background(
                Color("backColor")
                    .cornerRadius(15)
            )
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.7))
    }

    private var alertBody: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 20) {
                HStack {
                    if viewStore.currentInputType == .write {
                        TextField("機器・種目名", text: viewStore.binding(\.$trainingName))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        HStack {
                            Text("機器・種目名")
                                .font(.system(size: 11))
                            Spacer()
                            Picker("", selection: viewStore.binding(\.$trainingNameValueIndex)) {
                                ForEach(viewStore.trainingNameValues.indices, id: \.self) { index in
                                    Text(viewStore.trainingNameValues[index])
                                        .tag(index)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            Spacer()
                        }
                    }
                    Button(
                        action: {
                            viewStore.send(.updateInputType)
                        },
                        label: {
                            Text("切替")
                                .frame(width: 45)
                                .background(RoundedRectangle(cornerRadius: 10).stroke())
                        }
                    )
                }
                HStack {
                    TextField("",  text: viewStore.binding(\.$weight))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    Picker("", selection: viewStore.binding(\.$currentUnit)) {
                        ForEach(ValueUnit.allCases, id: \.self) { unit in
                            Text(unit.label)
                                .tag(unit)
                        }
                    }
                }
                HStack {
                    Picker("", selection: viewStore.binding(\.$count)) {
                        ForEach(0...100, id: \.self) { count in
                            Text("\(count)")
                                .tag(count)
                        }
                    }
                    .frame(width: 40)
                    Text("回")
                    Text("×")
                    Picker("", selection: viewStore.binding(\.$setCount)) {
                        ForEach(0...100, id: \.self) { count in
                            Text("\(count)")
                                .tag(count)
                        }
                    }
                    .frame(width: 40)
                    Text("セット")
                }
                TextField("メモ", text: viewStore.binding(\.$memo))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }

    private var alertBottom: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 0) {
                    Button(
                        action: {
                            viewStore.send(.alertDimiss, animation: .easeInOut)
                        },
                        label: {
                            Text("キャンセル")
                                .frame(width: buttonWidth)
                                .foregroundColor(.red)
                        }
                    )
                    Button(
                        action: {
                            viewStore.send(.setTrainignData)
                        },
                        label: {
                            Text("確定")
                                .frame(width: buttonWidth)
                        }
                    )
                }
                .padding(.vertical, 20)
            }
        }
    }

    private var buttonWidth: CGFloat {
        (UIScreen.main.bounds.width - 80) / 2
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        DataInputView(store: Store(initialState: DataInputStore.State(), reducer: DataInputStore()))
    }
}
