//
//  ChatScreenController.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AlamofireImage

fileprivate let avatarImageDiameter: UInt = 25
fileprivate let outgoingColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
fileprivate let incomingColor = UIColor.white

final class ChatScreenController: JSQMessagesViewController {

    var model: ChannelModel?

    fileprivate let server = Server()

    fileprivate var messages = [MessageModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Block", comment: "ChatScreenController block item"), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.title = NSLocalizedString("Back", comment: "ChatScreenController back item")
        automaticallyScrollsToMostRecentMessage = true
        // get think first user is interlocutor
        title = model?.users.first?.fullName
        // get think last user is current user
        senderDisplayName = model?.users.last?.fullName ?? ""
        senderId = "\(model?.users.last?.id ?? 0)"
        collectionView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        inputToolbar.contentView.leftBarButtonItem = nil
        inputToolbar.contentView.textView.layer.borderWidth = 0
        inputToolbar.contentView.backgroundColor = .white
        if let rightButton = inputToolbar.contentView.rightBarButtonItem {
            let button = UIButton(frame: rightButton.frame)
            inputToolbar.contentView.rightBarButtonItem = button
            button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        }
        log(inputToolbar.frame)
        loadMessages()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let bubble: JSQMessagesBubbleImage
        if message.senderId() == senderId {
            bubble = JSQMessagesBubbleImageFactory(bubble: UIImage.from(color: outgoingColor, with: CGSize(width: 20, height: 20)), capInsets: .zero).outgoingMessagesBubbleImage(with: outgoingColor)
        } else {
            bubble = JSQMessagesBubbleImageFactory(bubble: UIImage.from(color: outgoingColor, with: CGSize(width: 20, height: 20)), capInsets: .zero).outgoingMessagesBubbleImage(with: incomingColor)
        }
        return bubble
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        var avatar: JSQMessagesAvatarImage?
        if message.senderId() != senderId {
            if let image = message.sender?.avatarImage {
                avatar = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: avatarImageDiameter)
            } else {
                let firstCharacter = message.sender?.firstName.characters.first ?? Character("")
                let lastCharacter = message.sender?.lastName.characters.first ?? Character("")
                let initials = "\(String(firstCharacter).uppercased())\(String(lastCharacter).uppercased())"
                avatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initials,
                                                                   backgroundColor: .magenta,
                                                                   textColor: .white,
                                                                   font: UIFont.systemFont(ofSize: 15),
                                                                   diameter: avatarImageDiameter)
            }
        }
        return avatar
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell else { return UICollectionViewCell() }
        cell.textView.sizeToFit()
        cell.messageBubbleImageView.frame.size = cell.textView.frame.size
        if cell.avatarImageView.image == nil {
            cell.avatarContainerView.constraints.forEach { $0.constant = 0 }
        }
        let message = messages[indexPath.item]
        if message.senderId() == senderId {
            cell.textView.textColor = .white
            cell.messageBubbleImageView.round([.bottomLeft, .bottomRight, .topLeft], withRadius: 10)
        } else {
            cell.textView.textColor = .black
            cell.messageBubbleImageView.round([.topLeft, .bottomLeft, .bottomRight], withRadius: 10)
        }
        return cell
    }
}

extension ChatScreenController {

    func loadMessages() {
        guard let model = model else { log("model must be not nil"); return }
        server.getMessages(inChannel: model) { [weak self] result in
            guard let welf = self else { return }
            if case .failure(let error) = result {
                showText(error.localizedDescription)
                return
            }
            if case .success(let models) = result {
                welf.messages = models
                welf.messages.forEach { $0.sender?.setAvatarImage() }
                welf.collectionView.reloadData()
            }
        }
    }
}
