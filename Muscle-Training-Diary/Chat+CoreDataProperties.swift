//
//  Chat+CoreDataProperties.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var messageText: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var isSelf: Bool

}

extension Chat : Identifiable {

}
