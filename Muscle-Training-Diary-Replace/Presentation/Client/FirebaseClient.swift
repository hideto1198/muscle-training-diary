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
    var hasData: (Date) async throws -> Bool
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
            StorageRepository.set(trainingName: trainingData.trainingName)
        }, deleteTrainingData: { trainingData in
            try await FirebaseRepository.deleteTrainingData(userId: userId, trainingData: trainingData)
        }, hasData: { date in
            try await FirebaseRepository.hasData(userId: userId, date: date)
        })
    }
    
    static var previewValue: FirebaseClient {
        return Value(fetchTrainingData: {
            try await Task.sleep(for: .seconds(1))
            return [.fake, .fake, .fake, .feke2]
        }, saveTrainingData: { _ in
        }, deleteTrainingData: { _ in
        }, hasData: { _ in
            return true
        })
    }
}
