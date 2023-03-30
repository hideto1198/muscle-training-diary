//
//  ChartView.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/27.
//

import SwiftUI
import Charts
import ComposableArchitecture

struct ChartView: View {
    let store: StoreOf<ChartStore>

    var body: some View {
        VStack {
            picker
            chart
        }
        .padding(.all)
    }

    private var picker: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text("機器・種目名")
                Picker("", selection: viewStore.binding(get: \.trainingNameIndex, send: ChartStore.Action.updateTrainingName)) {
                    ForEach(viewStore.trainingNames.indices, id: \.self) { index in
                        Text(viewStore.trainingNames[index])
                            .tag(index)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    private var chart: some View {
        WithViewStore(store) { viewStore in
            Chart {
                ForEach(Array(viewStore.groupedDatas.keys.map { String($0) }).sorted { compare($0, $1) }, id: \.self) {
                    LineMark(
                        x: .value("日付", $0),
                        y: .value("記録", (viewStore.groupedDatas[$0]?.reduce(0, {
                            $0 + $1.value
                        }))!)
                    )
                }
//                ForEach(viewStore.trainingDatas.filter {$0.trainingName == viewStore.trainingNames[viewStore.trainingNameIndex]}) {
//                    LineMark(
//                        x: .value("日付", $0.trainingDate ?? ""),
//                        y: .value("記録", $0.value)
//                    )
//                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .symbol(by: .value("Form", "総量"))
//                    LineMark(
//                        x: .value("日付", $0.trainingDate ?? ""),
//                        y: .value("記録", $0.weight)
//                    )
//                    .lineStyle(StrokeStyle(lineWidth: 1))
//                    .symbol(by: .value("Form", "実重量"))
//                    .foregroundStyle(Color.red)
//                }
                if let selectedDate = viewStore.selectedDate {
                    RectangleMark(x: .value("Month", selectedDate), width: 25)
                                .foregroundStyle(.primary.opacity(0.2))
                                .annotation(
                                    position: viewStore.annotationPosition,
                                    alignment: .center,
                                    spacing: 0
                                ) {
                                    annotation
                                }
                }
            }
            .chartOverlay { proxy in
                    GeometryReader { _ in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                SpatialTapGesture()
                                    .onEnded { value in
                                        viewStore.send(.onTapped(proxy.value(atX: value.location.x, as: String.self)))

                                    }
                                    .exclusively(
                                        before: DragGesture()
                                            .onChanged { value in
                                                viewStore.send(.onTapped(proxy.value(atX: value.location.x, as: String.self),
                                                                         isExclusive: true))
                                            }
                                    )
                            )
                    }
                }
            .padding(.all)
        }
    }

    private var annotation: some View {
        WithViewStore(store) { viewStore in
            if let selectedItems = viewStore.selectedItems,
               let selectedDate = viewStore.selectedDate {
                VStack(alignment: .leading) {
                    Text(selectedDate)
                    Divider()
                    ForEach(selectedItems, id: \.self) { trainingData in
                        if String(format: "%.2f", trainingData.weight) != "0.00" {
                            Text("\(String(format: "%.2f", trainingData.weight)) \(trainingData.valueUnit.label) ")
                                .bold()
                        }
                        if trainingData.count != 0 {
                            HStack {
                                Text("\(trainingData.count)")
                                Text(" × ")
                                Text("\(trainingData.setCount)")
                                Text("セット")
                            }
                        }
                    }
                    Divider()
                    Text("総量: \(String(format: "%.2f", selectedItems.reduce(0, { $0 + $1.value })))")
                }
                .padding(.all)
                .foregroundColor(Color("backColor"))
                .background(Color.primary)
                .cornerRadius(16)
            }
        }
    }

    private func annotationContent(trainingData: TrainingData) -> some View {
        VStack(alignment: .leading) {
            Text(trainingData.trainingDate?.split(separator: " ")[0] ?? "")
            Divider()
            HStack {
                Text(String(format: "%.2f", trainingData.weight))
                Text(trainingData.valueUnit.label)
            }
            if trainingData.count != 0 {
                HStack {
                    Text("\(trainingData.count)")
                    Text(" × ")
                    Text("\(trainingData.setCount)")
                    Text("セット数")
                }
                Divider()
                Text("総重量: \(String(format: "%.2f", trainingData.value))")
                Text("実重量: \(String(format: "%.2f", trainingData.weight))")
            }
        }
        .padding(.all)
        .foregroundColor(Color("backColor"))
        .background(Color.primary)
        .cornerRadius(16)
    }

    private func compare(_ ldate: String, _ rdate: String) -> Bool {
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            return dateFormatter
        }

        return dateFormatter.date(from: ldate)?.compare(dateFormatter.date(from: rdate)!) == .orderedAscending
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(store: Store(initialState: ChartStore.State(), reducer: ChartStore()))
    }
}
