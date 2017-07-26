//
//  ChannelModel.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift

final class ChannelModel : Object {
    dynamic var id = -1
    dynamic var lastMessage = MessageModel()
    dynamic var unreadMessagesCount = -1
}
