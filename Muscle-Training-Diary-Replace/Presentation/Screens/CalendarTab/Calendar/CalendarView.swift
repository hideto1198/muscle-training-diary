//
//  CalendarView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/09.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: CalendarStore.self)
struct CalendarView: View {
    var store: StoreOf<CalendarStore>
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    ForEach(Week.weeks, id: \.self) {
                        Text($0.label)
                            .frame(width: proxy.size.width / 7)
                            .foregroundColor($0.foregroundColor)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 20)
            VStack(alignment: .leading, spacing: 0) {
                LazyVGrid(columns: Array(repeating: .init(spacing: 0), count: 7), spacing: 0) {
                    ForEachStore(store.scope(state: \.identifiedArray, action: \.calendarCellAction)) { childStore in
                        VStack(spacing: 0) {
                            Divider()
                            CalendarCellView(store: childStore)
                        }
                    }
                }
                Divider()
            }
            Spacer()
        }
    }
}

#Preview {
    CalendarView(store: Store(initialState: CalendarStore.State(year: 2024, month: 3),
                              reducer: { CalendarStore() }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Asset.lightGreen.swiftUIColor)
}
