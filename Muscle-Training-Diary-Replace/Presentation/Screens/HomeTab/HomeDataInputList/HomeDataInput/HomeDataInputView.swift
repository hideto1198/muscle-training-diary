//
//  HomeDataInputView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeDataInputStore.self)
struct HomeDataInputView: View {
    @Bindable var store: StoreOf<HomeDataInputStore>
    @FocusState var focusedField: HomeDataInputStore.State.Field?
    var state: HomeDataInputStore.ViewState {
        store.view
    }
    var pickerId: String { "picker" }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                datePicker
                Spacer()
                closeButton
            }
            .frame(height: 35)
            trainingName
                .frame(height: 35)
            count
                .frame(height: 35)
        }
        .foregroundColor(.black)
        .font(.custom("HanazomeFont", size: 16))
        .onAppear {
            send(.onAppear)
        }
        .bind($store.focusedField, to: $focusedField)
    }
    
    private var closeButton: some View {
        Button {
            send(.trashButtonTapped, animation: .easeOut)
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
    }
    
    private var datePicker: some View {
        HStack(spacing: 0) {
            Image(systemName: "calendar")
                .frame(width: 30)
            DatePicker("", selection: $store.training.date, displayedComponents: .date)
                .colorInvert()
                .colorMultiply(.black)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .labelsHidden()
        }
    }
    
    private var trainingName: some View {
        HStack(spacing: 0) {
            Image(systemName: "menucard")
                .frame(width: 30)
            if state.isTypingMode {
                TextField("", text: $store.training.name)
                    .roundedTextStyle(isEmpty: store.training.name.isEmpty)
                    .focused($focusedField, equals: .trainingName)
                    .onTapGesture {
                        send(.textEditorTapped(.trainingName))
                    }
            } else {
                Picker("", selection: $store.trainingNameSelection) {
                    ForEach(state.trainingNames.indices, id: \.self) {
                        Text(state.trainingNames[$0])
                            .tag($0)
                    }
                }
                .tint(.black)
                .offset(x: -10)
                Spacer()
            }
            Button {
                send(.inputModeChangeButtonTapped, animation: .bouncy)
            } label: {
                Text(state.inputModeChangeButtonLabel)
                    .font(.custom("HanazomeFont", size: 13))
            }
            .foregroundColor(.black)
            .tint(.white)
            .background(Color.white.cornerRadius(5))
            .buttonStyle(.bordered)
            .frame(width: 55)
        }
    }
    
    private var count: some View {
        HStack(spacing: 0) {
            Image(systemName: "dumbbell")
                .frame(width: 30)
            TextField("", text: $store.training.weight.text)
                .roundedTextStyle(isEmpty: store.training.weight.text.isEmpty)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .weight)
                .onTapGesture {
                    send(.textEditorTapped(.weight))
                }
            Picker("", selection: $store.training.unit) {
                ForEach(ValueUnit.allCases, id: \.self) {
                    Text($0.label)
                        .tag($0)
                }
            }
            .tint(.black)
            if store.training.unit == .kilogram {
                TextField("", text: $store.training.count.text)
                    .roundedTextStyle(isEmpty: store.training.count.text.isEmpty)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .count)
                    .onTapGesture {
                        send(.textEditorTapped(.count))
                    }
                Text("回")
                    .padding(.horizontal, 4)
                TextField("", text: $store.training.setCount.text)
                    .roundedTextStyle(isEmpty: store.training.setCount.text.isEmpty)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .setCount)
                    .onTapGesture {
                        send(.textEditorTapped(.setCount))
                    }
                Text("セット")
                    .frame(width: 55)
            } else {
                TextField("", text: $store.training.count.text)
                    .roundedTextStyle(isEmpty: store.training.count.text.isEmpty)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .count)
                    .onTapGesture {
                        send(.textEditorTapped(.count))
                    }
                Text("km")
                    .padding(.horizontal, 4)
            }
        }
        
    }
    
    private func triggerDatePickerPopover() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first,
            let picker = window.accessibilityDescendant(identifiedAs: pickerId) as? NSObject,
            let button = picker.buttonAccessibilityDescendant() as? NSObject
        {
            button.accessibilityActivate()
        }
    }
}

#Preview {
    HomeDataInputView(store: Store(initialState: HomeDataInputStore.State(base: .init()),
                                   reducer: { HomeDataInputStore() }))
    .background(Asset.doukutsuGray.swiftUIColor.opacity(0.6).frame(maxHeight: .infinity))
}
