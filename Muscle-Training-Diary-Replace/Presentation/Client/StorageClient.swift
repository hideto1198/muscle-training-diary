//
//  StorageClient.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

struct StorageClient {
    var setTrainingNames: (String) -> Void
    var getTrainingNames: () -> [String]
    var getUserId: () -> String
}

extension DependencyValues {
    var storageClient: StorageClient {
        get { self[StorageClient.self] }
        set { self[StorageClient.self] = newValue }
    }
}

extension StorageClient: DependencyKey {
    static var liveValue: StorageClient {
        return Value(setTrainingNames: { trainingName in
            StorageRepository.set(trainingName: trainingName)
        }, getTrainingNames: {
            StorageRepository.getTraingNames()
        }, getUserId: {
            StorageRepository.getUserId() ?? UUID().uuidString
        })
    }
    
    static var previewValue: StorageClient {
        return Value(setTrainingNames: { _ in
            
        }, getTrainingNames: {
            ["アシストチンニング", "アシストディップ", "アブドミナル", "アームカール", "アームカール(EZ)", "インクラインダンベルプレス", "インドアバイク", "グルート", "ケーブルクロスオーバー", "ケーブルフライ", "ショルダープレス", "シーテッドロー", "シーデッドレッグプレス", "スミスマシン(インクライン)", "スミスマシン(ベンチ)", "ダンベルカール", "ダンベルフライ", "ダンベルプレス", "ダンベルプレス(インクライン)", "チェストプレス", "デックラインプレス", "デッドリフト", "トライセップス", "トレッドミル", "トーソローテーション", "バイセップスカール", "ヒップアダクター", "ヒップアブダクター", "フロントラットプルダウン", "ベンチプレス", "ペクトラルフライ", "ラットプルダウン", "ラテラルレイズ", "リアテルトイド", "レッグエクステンション", "レッグカール", "レッグレイズ", "ロー"]
        }, getUserId: {
            return UUID().uuidString
        })
    }
}
