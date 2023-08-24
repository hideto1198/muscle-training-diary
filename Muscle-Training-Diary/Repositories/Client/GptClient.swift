//
//  GptClient.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

struct GptClient {
    var completion: @Sendable (_ messages: [Message]) async throws -> AsyncThrowingStream<ChatAPI.StreamEvent, Error>
    var listen: @Sendable () async throws -> AsyncThrowingStream<String, Error>
    var save: @Sendable (_ message: Message) async throws -> Bool
    var send: @Sendable () async throws -> Bool
}

extension DependencyValues {
    var gptClient: GptClient {
        get { self[GptClient.self] }
        set { self[GptClient.self] = newValue }
    }
}

extension GptClient: DependencyKey {
    static var liveValue: GptClient {
        let db = Firestore.firestore()
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { fatalError("ユーザー登録されてない") }
        return Value(completion: { messages in
            let url = "https://bonafide-api-faugn5toxa-uc.a.run.app/chatbot/chat"
            var body: [String: [Dictionary<String, Any>]] = ["messages": []]
            messages.filter({$0.userName == "me" || $0.userName == "bot"}).forEach {
                body["messages"]?.append($0.toDict)
            }
            return try await ChatAPI.shared.makeRequest(url: url, body: body).execute()
        }, listen: {
            return AsyncThrowingStream { continuation in
                let listener = db.collection("USERS").document(userId).collection("CHAT_DATA")
                    .addSnapshotListener { querySnapshot, error in
                        if let error { continuation.finish(throwing: error) }
                        if let querySnapshot {
                            querySnapshot.documents.forEach {
                                print("🧊\($0.documentID)🧊")
                                print("\($0.data())")
                            }
                            continuation.yield("")
                        }
                    }
                continuation.onTermination = { @Sendable _ in
                    listener.remove()
                }
            }
        }, save: { message in
            try await db.collection("USERS").document(userId).collection("CHAT_DATA").document().setData([
                "id": "\(message.id)",
                "userName": message.userName,
                "message": message.messageText,
                "timestamp": message.timestamp,
                "isSelf": message.isSelf
            ])
            return true
        }, send: {
            let messages: [String] = [
                "送信文字列",
                "トレーナーからの送信",
                "いい感じですね😀その調子で頑張りましょう！",
                "お疲れ様です！いいと思います🔥"
            ]
            try await db.collection("USERS").document(userId).collection("CHAT_DATA").document().setData([
                "id": "",
                "userName": "テスト　トレーナー",
                "message": messages.randomElement() ?? "",
                "timestamp": Date(),
                "isSelf": false
            ])
            return true
        })
    }
}

