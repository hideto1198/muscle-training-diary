//
//  ChatStore.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension NSNotification {
    static let scrollToBottom = Notification.Name.init("scrollToBottom")
}

struct ChatStore: ReducerProtocol {
    struct State: Equatable {
        var messages: [Message] = []
        @BindingState var newMessage: String = ""
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case push
        case fetchCompletion
        case chunk(String)
        case complete
        case delete
    }

    @Dependency(\.gptClient) var gptClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                let message = ChatDataManager.shared.getMessages()
                message.forEach {
                    state.messages.append(.init(userName: "",
                                                messageText: $0.messageText ?? "",
                                                timestamp: $0.timestamp ?? Date(),
                                                isSelf: $0.isSelf))
                }
                return .none
            case .push:
                if state.newMessage.isEmpty { return .none }
                let timestamp = Date()
                state.messages.append(
                    .init(userName: "",
                          messageText: state.newMessage,
                          timestamp: timestamp,
                          isSelf: true)
                )
                ChatDataManager.shared.save(message: .init(userName: "",
                                                           messageText: state.newMessage,
                                                           timestamp: Date(),
                                                           isSelf: true))
                state.messages.append(
                    .init(userName: "",
                          messageText: "",
                          timestamp: timestamp)
                )
                withAnimation {
                    NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
                }
                return EffectTask(value: .fetchCompletion)
            case .fetchCompletion:
                let message = state.newMessage
                state.newMessage = ""
                return .run { [message = message] send in
                    for try await streamEvent in try await gptClient.completion(message) {
                        switch streamEvent {
                        case .stream(let block):
                            await send(.chunk(block))
                        case .complete:
                            await send(.complete)
                        }
                    }
                }
            case .chunk(let data):
                if let lastIndex = state.messages.lastIndex(of: state.messages.last!) {
                    state.messages[lastIndex].messageText += data
                }
                return .none
            case .complete:
                withAnimation {
                    NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
                }
                if let lastIndex = state.messages.lastIndex(of: state.messages.last!) {
                    ChatDataManager.shared.save(message: state.messages[lastIndex])
                }
                return .none
            case .delete:
                state.messages.removeAll()
                ChatDataManager.shared.delete()
                return .none
            case .binding:
                return .none
            }
        }
    }
}
