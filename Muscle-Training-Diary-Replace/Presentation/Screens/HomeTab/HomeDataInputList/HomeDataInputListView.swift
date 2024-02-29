//
//  HomeDataInputListView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeDataInputListStore.self)
struct HomeDataInputListView: View {
    @Bindable var store: StoreOf<HomeDataInputListStore>
    var state: HomeDataInputListStore.ViewState {
        store.view
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                contentView
                if store.showSuccessView {
                    successView
                }
            }
            .background(
                ZStack {
                    Color.white
                    Asset.lightGreen.swiftUIColor
                        .opacity(0.6)
                }
                    .ignoresSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            send(.keyboardClose, animation: .interactiveSpring)
                        } label: {
                            Text("閉じる")
                        }
                    }
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 0 {
                            send(.rightSwiped)
                        } else if gesture.translation.width < 0 {
                            send(.leftSwiped)
                        }
                    }
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("データ追加")
                        .foregroundColor(.black)
                        .font(.custom("HanazomeFont", size: 18))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    private var successView: some View {
        VStack {
            store.successImage
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Text("保存したよ")
        }
        .padding()
        .background(
            Color.white
                .opacity(0.6)
                .cornerRadius(10)
        )
        .onAppear {
            send(.onAppearSuccessView)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEachStore(store.scope(state: \.homeDataInputStateList, action: \.homeDataInputActions)) {
                                HomeDataInputView(store: $0)
                                    .padding(.all, 5)
                                Divider()
                            }
                            Spacer()
                                .frame(height: 0)
                                .id("bottom")
                        }
                    }
                    .onChange(of: store.homeDataInputStateList) {
                        proxy.scrollTo("bottom")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(
                background
            )
            if !state.isKeyboardOpen {
                buttonArea
            }
        }
    }
    
    private var background: some View {
        ZStack {
            Asset.dekakabu.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            Asset.dekakabuAngry.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .opacity(0.4)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private var buttonArea: some View {
        HStack {
            Spacer()
            closeButton
            Spacer()
            addButton
            Spacer()
            saveButton
            Spacer()
        }
        .frame(height: 60)
        .padding(.vertical, 5)
    }
    
    private var closeButton: some View {
        Button {
            send(.dismissModal)
        } label: {
            VStack {
                Asset.chiikawaWithChiikabu.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 45)
                Text("とじる")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    private var addButton: some View {
        Button {
            send(.addInputData, animation: .easeIn)
        } label: {
            VStack(spacing: 0) {
                Asset.usagiMagic.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 45)
                Text("ふやす")
            }
        }
        .foregroundColor(.black)
        .padding()
    }
    
    private var saveButton: some View {
        Button {
            send(.saveButtonTapped)
        } label: {
            VStack {
                Asset.chiikabu2.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 45)
                Text("ほぞん")
            }
        }
        .foregroundColor(.black)
        .padding()
    }
}

#Preview("成功画面無し") {
    HomeDataInputListView(store: Store(initialState: HomeDataInputListStore.State(),
                                       reducer: { HomeDataInputListStore() }))
}

#Preview("成功画面あり") {
    HomeDataInputListView(store: Store(initialState: HomeDataInputListStore.State(showSuccessView: true),
                                       reducer: { HomeDataInputListStore() }))
}
