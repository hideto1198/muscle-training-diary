//
//  CalendarTabView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: CalendarTabStore.self)
struct CalendarTabView: View {
    @Bindable var store: StoreOf<CalendarTabStore>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(store.calendarStates.first(where: { $0.id == store.tabSelection })!.calendarModel.yearMonth)
                    .font(.custom("HanazomeFont", size: 28))
                    .padding(.horizontal)
                TabView(selection: $store.tabSelection) {
                    ForEach(Array(store.scope(state: \.identifiedArray, action: \.calendarAction).enumerated()),
                            id: \.element) { index, childStore in
                        CalendarView(store: childStore)
                            .tag(store.calendarStates[index].id)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Asset.lightGreen.swiftUIColor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ちいトレ")
                        .foregroundColor(.black)
                        .font(.custom("HanazomeFont", size: 18))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CalendarTabView(store: Store(initialState: CalendarTabStore.State(tabSelection: UUID()),
                                 reducer: { CalendarTabStore() }))
}
