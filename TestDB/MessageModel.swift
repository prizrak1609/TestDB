//
//  ChatModel.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift

final class MessageModel : Object {
    dynamic var channelId = -1
    dynamic var isRead = false
    dynamic var text = ""
    dynamic var created = Date()
    dynamic var sender = UserModel()
}
