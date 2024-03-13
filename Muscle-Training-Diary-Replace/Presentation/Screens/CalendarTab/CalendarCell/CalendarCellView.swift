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
    let store: StoreOf<CalendarCellStore>

    var body: some View {
        VStack {
            Text(store.entity.date)
                .foregroundColor(store.entity.week.foregroundColor)
            if !store.entity.date.isEmpty {
                Asset.hachiwareAndChiikawa.swiftUIImage
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(height: 60)
        .padding(5)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.6))
        .onTapGesture {
            send(.onTapped)
        }
    }
}

#Preview("金曜日") {
    CalendarCellView(store: Store(initialState: CalendarCellStore.State(entity: .init(date: "1",week: .fri)),
                                  reducer: { CalendarCellStore() }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Asset.lightGreen.swiftUIColor)
}

#Preview("土曜日") {
    CalendarCellView(store: Store(initialState: CalendarCellStore.State(entity: .init(date: "1",week: .sat)),
                                  reducer: { CalendarCellStore() }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Asset.lightGreen.swiftUIColor)
}
