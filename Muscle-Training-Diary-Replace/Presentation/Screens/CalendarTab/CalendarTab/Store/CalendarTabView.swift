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
    @State private var scrollViewPosition: Int? = 1
    @Bindable var store: StoreOf<CalendarTabStore>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(store.calendarStates[store.calendarTabSelection!].calendarModel.yearMonth)
                    .font(.custom("HanazomeFont", size: 28))
                    .padding(.horizontal)
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(Array(store.scope(state: \.calendarStates, action: \.calendarAction).enumerated()),
                                    id: \.element) { index, childStore in
                                CalendarView(store: childStore)
                                    .id(index)
                                    .frame(width: UIScreen.main.bounds.width)
                            }
                        }
                        .scrollTargetLayout()
                        .onAppear {
                            Task {
                                proxy.scrollTo(store.calendarTabSelection)
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $scrollViewPosition)
                    .onChange(of: scrollViewPosition) { oldValue, newValue in
                        if newValue == 0 {
                            scrollViewPosition = oldValue
                        }
                    }
                }
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
        .bind($store.calendarTabSelection, to: $scrollViewPosition)
    }
}

#Preview {
    CalendarTabView(store: Store(initialState: CalendarTabStore.State(),
                                 reducer: { CalendarTabStore() }))
}
