//
//  CalendarTabView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import SwiftUI
import ComposableArchitecture

struct CalendarTabView: View {
    @Bindable var store: StoreOf<CalendarTabStore>
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                TabView(selection: $store.calendarTabSelection) {
                    ForEach(Array(store.scope(state: \.calendarStates, action: \.calendarAction).enumerated()),
                            id: \.element) { index, childStore in
                        CalendarView(store: childStore)
                            .tag(index)
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
    CalendarTabView(store: Store(initialState: CalendarTabStore.State(),
                                 reducer: { CalendarTabStore() }))
}
