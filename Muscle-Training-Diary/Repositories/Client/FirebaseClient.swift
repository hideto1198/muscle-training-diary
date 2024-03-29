//
//  FirebaseClient.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

struct FirebaseClient {
    var setTrainingData: @Sendable (_ trainingData: TrainingData) async throws -> Bool
    var fetchTrainingData: @Sendable () async throws -> [TrainingData]
    var deleteTrainingData: @Sendable (_ trainingData: TrainingData) async throws -> Bool
    var listen: @Sendable () async throws -> AsyncThrowingStream<[Message], Error>
}

extension DependencyValues {
    var firebaseClient: FirebaseClient {
        get { self[FirebaseClient.self] }
        set { self[FirebaseClient.self] = newValue }
    }
}

extension FirebaseClient: DependencyKey {
    static var liveValue: FirebaseClient {
        let db = Firestore.firestore()
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { fatalError("ユーザー登録されてない") }
        return Value(setTrainingData: { trainingData in
            let recordDate: String = trainingData.trainingDate ?? trainingData.recordDate
            try await db.collection("USERS").document(userId).collection("TRAINING_DATA").document(recordDate).setData([
                "TRAINING_NAME": trainingData.trainingName,
                "WEIGHT": trainingData.weight,
                "VALUE_UNIT": trainingData.valueUnit.label,
                "COUNT": trainingData.count,
                "SET_COUNT": trainingData.setCount,
                "MEMO": trainingData.memo
            ])
            return true
        }, fetchTrainingData: {
            var result: [TrainingData] = []
            let response = try await db.collection("USERS").document(userId).collection("TRAINING_DATA").getDocuments()
            response.documents.forEach {
                result.append(
                    TrainingData(
                        trainingDate: $0.documentID,
                        trainingName: $0.data()["TRAINING_NAME"] as? String ?? "",
                        weight: $0.data()["WEIGHT"] as? Double ?? 0.0,
                        valueUnit: ValueUnit.type(unitString: $0.data()["VALUE_UNIT"] as? String ?? "分"),
                        count: $0.data()["COUNT"] as? Double ?? 0,
                        setCount: $0.data()["SET_COUNT"] as? Int ?? 0,
                        memo: $0.data()["MEMO"] as? String ?? ""
                    )
                )
            }
            return result.sorted(by: { $0.trainingDate! > $1.trainingDate! })
        }, deleteTrainingData: { trainingData in
            guard let trainingDate = trainingData.trainingDate else { fatalError("nil") }
            try await db.collection("USERS").document(userId).collection("TRAINING_DATA").document(trainingDate).delete()
            return true
        }, listen: {
            return AsyncThrowingStream { continuation in
                let chatRef = Firestore.firestore().collection("USERS").document(userId).collection("CHAT_DATA")
                let listener = chatRef
                    .order(by: "timestamp")
                    .addSnapshotListener { querySnapshot, error in
                        if let error { continuation.finish(throwing: error) }
                        if let querySnapshot {
                            var listenedValue: [Message] = []
                            querySnapshot.documents.filter({ $0.data()["id"] as? String == "" }).forEach {
                                listenedValue.append(Message(userName: $0.data()["userName"] as! String,
                                                             messageText: $0.data()["message"] as! String,
                                                             timestamp: ($0.data()["timestamp"] as! Timestamp).dateValue(),
                                                             isSelf: $0.data()["isSelf"] as! Bool)
                                )
                                chatRef.document($0.documentID).updateData(["id": UUID().uuidString])
                            }
                            continuation.yield(listenedValue)
                        }
                    }
                continuation.onTermination = { @Sendable _ in
                    listener.remove()
                }
            }
        })
    }
}
