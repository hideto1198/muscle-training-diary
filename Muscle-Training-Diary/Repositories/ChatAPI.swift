//
//  APICaller.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/02.
//

import Foundation
import Alamofire

struct ChatAPI: Equatable {
    static var shared = ChatAPI()
    var request: URLRequest?

    mutating func makeRequest(url: String, body: [String: Any]? = nil) -> Self {
        guard let url = URL(string: url) else { fatalError("有効なURLを指定してください") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        if let body = body {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { fatalError() }
            request.httpBody = httpBody
        }
        return ChatAPI(request: request)
    }

    func execute() async throws -> AsyncThrowingStream<StreamEvent, Error> {
        guard let request = request else { fatalError("requestを生成してください") }
        return AsyncThrowingStream { continuation in
            AF.streamRequest(request)
                .responseStreamString { stream in
                    switch stream.event {
                    case .stream(let string):
                        continuation.yield(.stream(try string.get()))
                    case .complete(_):
                        print("🔥完了🔥")
                        continuation.yield(.complete)
                        continuation.finish()
                    }
                }
        }
    }
}

extension ChatAPI {
    enum StreamEvent {
        case stream(String)
        case complete
    }
}
