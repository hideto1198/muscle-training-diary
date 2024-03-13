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
            HStack {
                Button {
                    send(.backwordButtonTapped, animation: .bouncy)
                } label: {
                    Text("←")
                }
                Text("\(store.calendarModel.yearMonth)")
                Button {
                    send(.forwardButtonTapped, animation: .bouncy)
                } label: {
                    Text("→")
                }
            }
            .padding(.vertical)
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
                ForEach(0 ..< store.calendarModel.dates.count, id: \.self) { index in
                    Divider()
                    HStack(spacing: 0) {
                        ForEachStore(store.scope(state: \.calendarModel.dates[index].identifiableArray, action: \.calendarCellAction)) {
                            CalendarCellView(store: $0)
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
}
