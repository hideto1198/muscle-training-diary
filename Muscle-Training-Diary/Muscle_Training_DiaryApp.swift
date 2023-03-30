//
//  Muscle_Training_DiaryApp.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import SwiftUI
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
        guard UserDefaults.standard.string(forKey: "userId") == nil else { return }
        let uuid: String = UUID().uuidString
        UserDefaults.standard.set(uuid, forKey: "userId")
    }
}

@main
struct Muscle_Training_DiaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
