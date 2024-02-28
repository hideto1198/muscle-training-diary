//
//  FirebaseClient.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct FirebaseClient {
    var fetchTrainingData: () async throws -> [Training]
    var saveTrainingData: (TrainingData) throws -> Void
    var deleteTrainingData: (TrainingData) async throws -> Void
}

extension DependencyValues {
    var firebaseClient: FirebaseClient {
        get { self[FirebaseClient.self] }
        set { self[FirebaseClient.self] = newValue }
    }
}

extension FirebaseClient: DependencyKey {
    private static var userId: String {
        guard let userId = StorageRepository.getUserId() else { fatalError() }
        return userId
    }

    static var liveValue: FirebaseClient {
        return Value(fetchTrainingData: {
            return try await FirebaseRepository.fetchTrainingData(userId: userId)
                .map { $0.convert() }
        }, saveTrainingData: { trainingData in
            try FirebaseRepository.saveTrainingData(userId: userId, trainingData: trainingData)
        }, deleteTrainingData: { trainingData in
            try await FirebaseRepository.deleteTrainingData(userId: userId, trainingData: trainingData)
        })
    }
    
    static var previewValue: FirebaseClient {
        return Value(fetchTrainingData: {
            try await Task.sleep(for: .seconds(2))
            return [.fake, .fake, .fake]
        }, saveTrainingData: { _ in
        }, deleteTrainingData: { _ in
        })
    }
}
