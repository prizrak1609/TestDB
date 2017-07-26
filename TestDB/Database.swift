//
//  Database.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift

// disable because when use Realm need to write let realm = try! Realm() or try! write {}
// swiftlint:disable force_try
final class Database {

    func save(channel: ChannelModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(channel, update: true)
        }
    }

    func save(user: UserModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }

    func save(message: MessageModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(message, update: true)
        }
    }

    func delete(channel: ChannelModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(channel)
        }
    }

    func getChannels() -> [ChannelModel] {
        let realm = try! Realm()
        let result = realm.objects(ChannelModel.self)
        return result.map { $0 }
    }

    func getMessages(inChannel channel: ChannelModel) -> [MessageModel] {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "channelId = %@", channel.id)
        let result = realm.objects(MessageModel.self).filter(predicate)
        return result.map { $0 }
    }
}
// swiftlint:enable unwrap
