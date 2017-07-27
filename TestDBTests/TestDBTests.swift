//
//  TestDBTests.swift
//  TestDBTests
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest
import RealmSwift
@testable import TestDB

class TestDBTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true)
    }

    func testDBSaveDeleteGetChannelsModel() {
        let user1 = UserModel()
        user1.firstName = "1"
        user1.lastName = "1"
        user1.id = 0
        user1.userName = "11"

        let user2 = UserModel()
        user2.firstName = "2"
        user2.lastName = "2"
        user2.id = 1
        user2.userName = "22"

        let user3 = UserModel()
        user3.firstName = "3"
        user3.lastName = "3"
        user3.id = 1
        user3.userName = "33"

        let message = MessageModel()
        message.channelId = 0
        message.messageText = "text"
        message.sender = user3

        let channel = ChannelModel()
        channel.id = 0
        let users = List<UserModel>()
        users.append(objectsIn: [user1, user2])
        channel.users = users
        channel.lastMessage = message

        let dataBase = Database()
        dataBase.save(channel: channel)
        let channel1 = ChannelModel()
        channel1.id = 1
        channel1.users = users
        channel1.lastMessage = message
        dataBase.save(channel: channel1)

        let channels = dataBase.getChannels()
        XCTAssertFalse(channels.isEmpty)
        XCTAssertTrue(channel == channels[channels.count - 2])
        XCTAssertTrue(channel1 == channels.last)
    }
}
