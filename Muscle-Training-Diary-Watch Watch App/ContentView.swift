//
//  ContentView.swift
//  Muscle-Training-Diary-Watch Watch App
//
//  Created by 東　秀斗 on 2023/05/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var manager = WatchConnection()

    var body: some View {
        Group {
            if (manager.activities.isEmpty) {
                ProgressView()
            } else {
                dataSelectView
            }
        }
        .onAppear {
            manager.sendData()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                manager.sendData()
            default:
                break
            }
        }
    }

    var dataSelectView: some View {
        Form {
            Section {
                Picker("機器・種目", selection: $manager.activityName) {
                    ForEach(manager.activities, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: manager.activityName) { newValue in
                    manager.updateDate(activityName: newValue)
                }
                Picker("日付", selection: $manager.trainingDate) {
                    ForEach(manager.trainingDateList[manager.activityName] ?? [], id: \.self) {
                        Text($0)
                    }
                }
            } header: {
                Text("データ選択")
            }
            Section {
                ForEach(manager.trainingData[manager.activityName]?.filter({ $0.trainingDate!.contains(manager.trainingDate) }).sorted(by: { $0.weight > $1.weight }) ?? [], id: \.self) { data in
                    VStack(alignment: .leading) {
                        if (data.weight != 0.0) {
                            if #available(watchOS 9.0, *) {
                                HStack {
                                    Text(String(format: "%.2f", data.weight))
                                    Text(data.valueUnit.label)
                                }.bold()
                            } else {
                                HStack {
                                    Text(String(format: "%.2f", data.weight))
                                    Text(data.valueUnit.label)
                                }
                            }
                        }
                        if (data.setCount != 0) {
                            HStack {
                                Text(String(format: "%.0f", data.count))
                                Text("回 × ")
                                Text("\(data.setCount)セット")
                            }
                        } else {
                            Text("\(String(format: "%.2f", data.count))km")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } header: {
                Text("結果")
            }
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
