//
//  HomeWatchConnection.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/23.
//

import Foundation
import WatchConnectivity

class HomeWatchConnection: NSObject {
    var session: WCSession
    var trainigData: [String: [[String: Any]]]?

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }

    func sendData(trainingData: [String: [[String: Any]]]) {
        print("🔥sendData🔥")
        session.sendMessage(["trainingData": trainingData], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }

}

extension HomeWatchConnection: WCSessionDelegate {
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation on iPhone")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let trainigData = self.trainigData else { return }
        session.sendMessage(trainigData, replyHandler: nil)
    }
}
