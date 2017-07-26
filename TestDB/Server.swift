//
//  Server.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias ServerChannelCompletion = (Result<[ChannelModel]>) -> Void
typealias ServerChannelMessagesCompletion = (Result<[MessageModel]>) -> Void

final class Server {

    fileprivate let baseURLPath = "https://iostest.db2dev.com"

    fileprivate let database = Database()

    func getChannels(_ completion: @escaping ServerChannelCompletion) {
        completion(.success(database.getChannels()))
        let url = "\(baseURLPath)/api/chat/channels/"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url).responseJSON { [weak self] response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let welf = self else { return }
            let result = welf.parseJSON(response: response)
            if case .failure(let error) = result {
                completion(.failure(error))
                return
            }
            if case.success(let json) = result {
                let channels = json["channels"].arrayValue
                var result = [ChannelModel]()
                for channelJSON in channels {
                    let channelModel = ChannelModel()
                    channelModel.id = channelJSON["id"].intValue
                    channelModel.unreadMessagesCount = channelJSON["unread_messages_count"].intValue
                    let messageJSON = channelJSON["last_message"]
                    let messageModel = MessageModel()
                    channelModel.lastMessage = messageModel
                    messageModel.channelId = channelModel.id
                    messageModel.isRead = messageJSON["is_read"].boolValue
                    messageModel.text = messageJSON["text"].stringValue
                    if let date = dateFormatter.date(from: messageJSON["create_date"].stringValue) {
                        messageModel.created = date
                    }
                    let userJSON = messageJSON["sender"]
                    let user = UserModel()
                    messageModel.sender = user
                    user.id = userJSON["id"].intValue
                    user.firstName = userJSON["first_name"].stringValue
                    user.lastName = userJSON["last_name"].stringValue
                    user.photoURLPath = userJSON["photo"].stringValue
                    user.userName = userJSON["username"].stringValue
                    welf.database.save(channel: channelModel)
                    result.append(channelModel)
                }
                completion(.success(result))
            }
        }
    }

    func getMessages(inChannel channel: ChannelModel, _ completion: @escaping ServerChannelMessagesCompletion) {
        let url = "\(baseURLPath)/api/chat/channels/\(channel.id)/messages/"
        completion(.success(database.getMessages(inChannel: channel)))
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url).responseJSON { [weak self] response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let welf = self else { return }
            let result = welf.parseJSON(response: response)
            if case .failure(let error) = result {
                completion(.failure(error))
                return
            }
            if case .success(let json) = result {
                let messages = json["messages"].arrayValue.map { messageJSON -> MessageModel in
                    let messageModel = MessageModel()
                    messageModel.channelId = channel.id
                    messageModel.isRead = messageJSON["is_read"].boolValue
                    messageModel.text = messageJSON["text"].stringValue
                    if let date = dateFormatter.date(from: messageJSON["create_date"].stringValue) {
                        messageModel.created = date
                    }
                    let userJSON = messageJSON["sender"]
                    let userModel = UserModel()
                    messageModel.sender = userModel
                    userModel.id = userJSON["id"].intValue
                    userModel.firstName = userJSON["first_name"].stringValue
                    userModel.lastName = userJSON["last_name"].stringValue
                    userModel.photoURLPath = userJSON["photo"].stringValue
                    userModel.userName = userJSON["username"].stringValue
                    welf.database.save(message: messageModel)
                    return messageModel
                }
                completion(.success(messages))
            }
        }
    }

    fileprivate func parseJSON(response: DataResponse<Any>) -> Result<JSON> {
        if let error = response.error ?? response.result.error {
            return .failure(error)
        }
        if let result = response.result.value {
            return .success(JSON(result))
        }
        return .failure(NSError(domain: NSLocalizedString("fail to get response", comment: "Server parseJSON"), code: 0, userInfo: nil))
    }
}
