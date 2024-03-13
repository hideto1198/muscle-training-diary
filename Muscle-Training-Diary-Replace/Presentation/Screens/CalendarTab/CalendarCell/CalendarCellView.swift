//
//  CalendarCellView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: CalendarCellStore.self)
struct CalendarCellView: View {
    var store: StoreOf<CalendarCellStore>

    var body: some View {
        VStack {
            Text(store.isTapped ? "Tapped" : "UnTapped")
            if store.loadStauts == .loading {
                ProgressView()
            } else {
                Text(store.entity.date)
                    .foregroundColor(store.entity.week.foregroundColor)
                if store.hasData {
                    Asset.hachiwareAndChiikawa.swiftUIImage
                        .resizable()
                        .scaledToFit()
                } else {
                    Spacer()
                }
            }
        }
        .frame(height: 60)
        .padding(5)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.6))
        .onTapGesture {
            send(.onTapped)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview("金曜日") {
    CalendarCellView(store: Store(initialState: CalendarCellStore.State(year: 2023, month: 3, entity: .init(date: "1",week: .fri)),
                                  reducer: { CalendarCellStore() }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Asset.lightGreen.swiftUIColor)
}

#Preview("土曜日") {
    CalendarCellView(store: Store(initialState: CalendarCellStore.State(year: 2023, month: 3, entity: .init(date: "1",week: .sat)),
                                  reducer: { CalendarCellStore() }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Asset.lightGreen.swiftUIColor)
}
