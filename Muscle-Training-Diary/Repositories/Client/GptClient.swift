//
//  GptClient.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//

import Foundation
import ComposableArchitecture

struct GptClient {
    var completion: @Sendable (_ message: String) async throws -> AsyncThrowingStream<ChatAPI.StreamEvent, Error>
}

extension DependencyValues {
    var gptClient: GptClient {
        get { self[GptClient.self] }
        set { self[GptClient.self] = newValue }
    }
}

extension GptClient: DependencyKey {
    static var liveValue: GptClient {
        return Value(completion: { message in
            let url = "https://bonafide-api-faugn5toxa-uc.a.run.app/chatbot/chat"
            let body: [String: Any] = ["message": message]
            return try await ChatAPI.shared.makeRequest(url: url, body: body).execute()
        })
    }
}

