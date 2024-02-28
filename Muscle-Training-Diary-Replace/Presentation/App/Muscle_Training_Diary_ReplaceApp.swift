//
//  Muscle_Training_Diary_ReplaceApp.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import SwiftData

import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        register()
        return true
    }
    
    private func register() {
        guard StorageRepository.getUserId() == nil else { return }
        StorageRepository.set(userId: UUID().uuidString)
    }
}

@main
struct Muscle_Training_Diary_ReplaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .font(.custom("HanazomeFont", size: 16))
        }
    }
}
