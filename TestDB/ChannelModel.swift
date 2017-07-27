//
//  ChannelModel.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

final class ChannelModel : Object {
    dynamic var id = -1
    dynamic var lastMessage: MessageModel?
    dynamic var unreadMessagesCount = -1
    var users = List<UserModel>()

    override class func primaryKey() -> String {
        return "id"
    }

    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        lastMessage = MessageModel(json: json["last_message"])
        unreadMessagesCount = json["unread_messages_count"].intValue
        let usersArray = json["users"].arrayValue.map { UserModel(json: $0) }
        users.removeAll()
        users.append(objectsIn: usersArray)
    }
}
