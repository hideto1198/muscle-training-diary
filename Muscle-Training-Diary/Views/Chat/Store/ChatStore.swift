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
        case save(Message)
        case saveCompletaion(TaskResult<Bool>)
        case receive([Message])
        case send
        case sendResponse(TaskResult<Bool>)
    }

    @Dependency(\.gptClient) var gptClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                let message = ChatDataManager.shared.getMessages()
                message.forEach {
                    state.messages.append(.init(userName: $0.userName ?? "",
                                                messageText: $0.messageText ?? "",
                                                timestamp: $0.timestamp ?? Date(),
                                                isSelf: $0.isSelf))
                }
                return .none
            case .push:
                if state.newMessage.isEmpty { return .none }
                let message: Message = .init(userName: "me",
                                            messageText: state.newMessage,
                                            timestamp: Date(),
                                            isSelf: true)
                state.messages.append(message)
                ChatDataManager.shared.save(message: message)
                state.messages.append(
                    .init(userName: "bot",
                          messageText: "",
                          timestamp: Date())
                )
                withAnimation {
                    NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
                }
                return .merge(
                    .run { [message = message] send in
                        await send(.save(message))
                    },
                    EffectTask(value: .fetchCompletion)
                )
            case .fetchCompletion:
                state.newMessage = ""
                return .run { [messages = state.messages.suffix(10).map { $0 }] send in
                    for try await streamEvent in try await gptClient.completion(messages) {
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
                    return .run { [message = state.messages[lastIndex]] send in
                        await send(.save(message))
                    }
                }
                return .none
            case .delete:
                state.messages.removeAll()
                ChatDataManager.shared.delete()
                return .none
            case .save(let message):
                return .task { [message = message] in
                    await .saveCompletaion(TaskResult { try await gptClient.save(message) })
                }
            case .saveCompletaion(.success(_)):
                return .none
            case .saveCompletaion(.failure):
                return .none
            case .receive(let messages):
                state.messages += messages
                messages.forEach {
                    ChatDataManager.shared.save(message: $0)
                }
                withAnimation {
                    NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
                }
                return .none
            case .send:
                return .task {
                    await .sendResponse(TaskResult { try await gptClient.send() })
                }
            case .sendResponse:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
