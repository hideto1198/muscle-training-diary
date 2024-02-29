//
//  HomeGraphView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/29.
//

import SwiftUI
import Charts
import ComposableArchitecture

@ViewAction(for: HomeGraphStore.self)
struct HomeGraphView: View {
    @Bindable var store: StoreOf<HomeGraphStore>

    var body: some View {
        VStack {
            datePickers
            if store.groupedData.isEmpty {
                dataEmpty
            } else {
                chart
                    .background(
                        Asset.chiiawaUsagiPicture.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .opacity(0.4)
                            .frame(height: 250)
                    )
                Group {
                    if store.selectedDate != nil {
                        ScrollView {
                            ForEach(store.filteredDataList, id: \.self) { data in
                                HomeDataView(training: data)
                                    .padding(.bottom, 3)
                            }
                        }
                    } else {
                        notSelectedDate
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
            }
        }
        .background(Asset.lightGreen.swiftUIColor)
    }
    
    private var notSelectedDate: some View {
        ZStack {
            Asset.chiikawaPicture.swiftUIImage
                .resizable()
                .scaledToFit()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var dataEmpty: some View {
        VStack {
            Asset.hachiwareShobon.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            Text("該当するデータはないよ。")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    private var datePickers: some View {
        HStack {
            Text("日付")
            DatePicker("", selection: $store.startDate, displayedComponents: .date)
                .colorInvert()
                .colorMultiply(.black)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .labelsHidden()
            Text("〜")
            DatePicker("", selection: $store.endDate, displayedComponents: .date)
                .colorInvert()
                .colorMultiply(.black)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .labelsHidden()
        }
        .padding(.horizontal)
    }
    
    private var chart: some View {
        Chart {
            ForEach(store.groupedData.sorted(by: <), id: \.key) { key, value in
                LineMark(
                    x: .value("日付", key),
                    y: .value("記録", value)
                )
                .interpolationMethod(.catmullRom)
            }
            if let selectedDate = store.selectedDate {
                PointMark(x: .value("日付", selectedDate),
                          y: .value("記録", store.groupedData[selectedDate] ?? 0.0))
                .symbol(symbol: {
                    Asset.shisa.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                })
            }
        }
        .chartOverlay { proxy in
            GeometryReader { _ in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                send(.graphTapped(proxy.value(atX: value.location.x, as: String.self)))

                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        send(.graphTapped(proxy.value(atX: value.location.x, as: String.self),
                                                                 isExclusive: true))
                                    }
                            )
                    )
            }
        }
        .padding()
    }
}

#Preview("データあり") {
    HomeGraphView(store: Store(initialState: HomeGraphStore.State(trainingDataList: [.fake,]),
                               reducer: { HomeGraphStore() }))
}

#Preview("データなし") {
    HomeGraphView(store: Store(initialState: HomeGraphStore.State(trainingDataList: []),
                               reducer: { HomeGraphStore() }))
}
