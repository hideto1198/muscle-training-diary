//
//  WatchConnection.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/22.
//

import Foundation
import WatchConnectivity

class WatchConnection: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var activities: [String] = []
    @Published var activityName: String = ""
    @Published var trainingData: [String: [TrainingData]] = [:]
    @Published var trainingDate: String = ""
    @Published var trainingDateList: [String: [String]] = [:]

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }

    func sendData() {
        session.sendMessage(["data": "data"], replyHandler: nil) { error in
            print(error)
        }
    }
    
    func updateDate(activityName: String) {
        self.trainingDate = self.trainingDateList[activityName]?.first ?? ""
    }
}

extension WatchConnection {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            fatalError(error.localizedDescription)
        } else {
            print("The session has completed activation on iPhone")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("🔥receive on watchOS🔥")
        guard let trainigData = message["trainingData"] as? [String: [[String: Any]]] else { fatalError("Not found data or Can't parse data") }
        Task { @MainActor in
            self.activities = trainigData.keys.map{ $0 }.sorted()
            trainigData.forEach {
                self.trainingData[$0] = $1.map { TrainingData.fromDict(dict: $0) }
                self.trainingDateList[$0] = Array(Set($1.map { ($0["trainingDate"] as? String ?? "").components(separatedBy: " ")[0] })).sorted(by: { compare($0, $1) })
            }
            self.activityName = self.activities.first ?? ""
            self.trainingDate = self.trainingDateList[self.activityName]?.first ?? ""
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }
}

extension WatchConnection {
    private func compare(_ ldate: String, _ rdate: String) -> Bool {
        let dateFormatter = dateFormatter(dateFormat: "yyyy年MM月dd日")
        return dateFormatter.date(from: ldate)?.compare(dateFormatter.date(from: rdate)!) == .orderedDescending
    }

    private func dateFormatter(dateFormat: String) -> DateFormatter {
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = dateFormat
            dateFormatter.locale = Locale(identifier: "ja_JP")
            return dateFormatter
        }

        return dateFormatter
    }
}
