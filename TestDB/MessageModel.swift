//
//  ChatModel.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import JSQMessagesViewController

final class MessageModel : Object, JSQMessageData {
    dynamic var channelId = -1
    dynamic var isRead = false
    dynamic var messageText = ""
    dynamic var created = Date()
    dynamic var sender: UserModel?

    convenience init(json: JSON) {
        self.init()
        isRead = json["is_read"].boolValue
        messageText = json["text"].stringValue
        if let date = dateFormatter.date(from: json["create_date"].stringValue) {
            created = date
        }
        sender = UserModel(json: json["sender"])
    }

    func senderId() -> String! {
        return "\(sender?.id ?? 0)"
    }

    func senderDisplayName() -> String! {
        return "\(sender?.fullName ?? "")"
    }

    func date() -> Date! {
        return created
    }

    func isMediaMessage() -> Bool {
        return false
    }

    func messageHash() -> UInt {
        return UInt(abs(channelId.hashValue + created.hashValue))
    }

    func text() -> String! {
        return messageText
    }
}
