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
            chart
            if let selectedDate = store.selectedDate {
                ScrollView {
                    ForEach(store.trainingDataList.filter { $0.formattedDate == selectedDate }, id: \.self) { data in
                        HomeDataView(training: data)
                            .padding(.bottom, 3)
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
            }
        }
        .background(Asset.lightGreen.swiftUIColor)
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

#Preview {
    HomeGraphView(store: Store(initialState: HomeGraphStore.State(trainingDataList: [.fake,]),
                               reducer: { HomeGraphStore() }))
}
