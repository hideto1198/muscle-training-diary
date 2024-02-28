//
//  FirebaseRepository.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import FirebaseFirestore

enum FirebaseRepository {
    private static var db = Firestore.firestore()

    static func fetchTrainingData(userId: String) async throws -> [TrainingData] {
        let response = try await db.collection("users").document(userId).collection("training_data")
            .order(by: "training_date", descending: true)
            .getDocuments()
        return try response.documents.map { try $0.data(as: TrainingData.self) }
    }
    
    static func saveTrainingData(userId: String, trainingData: TrainingData) throws -> Void {
        try db.collection("users").document(userId).collection("training_data").document(trainingData.id.uuidString).setData(from: trainingData)
    }
    
    static func deleteTrainingData(userId: String, trainingData: TrainingData) async throws -> Void {
        let ref = try await db.collection("users").document(userId).collection("training_data")
            .whereField("id", isEqualTo: trainingData.id.uuidString)
            .getDocuments()
        ref.documents.forEach {
            $0.reference.delete()
        }
    }
}
