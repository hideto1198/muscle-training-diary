//
//  ChatDataManager.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//

import Foundation
import CoreData

class ChatDataManager {
    static let shared = ChatDataManager()
    private let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load store: \(error)")
            }
        }
    }

    func save(message: Message) {
        let context = container.viewContext
        let chatMessage = Chat(context: context)
        chatMessage.userName = message.userName
        chatMessage.messageText = message.messageText
        chatMessage.isSelf = message.isSelf
        chatMessage.timestamp = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save message: \(error)")
        }
    }

    func getMessages() -> [Chat] {
        let context = container.viewContext
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Chat.timestamp, ascending: true)
        request.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch messages: \(error)")
            return []
        }
    }

    func delete() {
        let context = container.viewContext
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()

        do {
            let data = try context.fetch(request)
            data.forEach {
                context.delete($0)
            }
            try context.save()
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
}
