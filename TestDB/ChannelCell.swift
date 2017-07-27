//
//  MessageCell.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import AlamofireImage

final class ChannelCell: UITableViewCell {
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var lastMessageLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var unreadMessagesCountLabel: UILabel!

    static let height: CGFloat = 70

    var model: ChannelModel? {
        didSet {
            guard let model = model,
                let lastMessage = model.lastMessage,
                let sender = lastMessage.sender
                else { return }
            if let url = URL(string: sender.photoURLPath) {
                avatarImageView.af_setImage(withURL: url)
            }
            nameLabel.text = sender.fullName
            lastMessageLabel.text = lastMessage.messageText
            let calendar = Calendar.current
            let nowComponents = calendar.dateComponents([.day, .month], from: Date())
            let messageComponents = calendar.dateComponents([.day, .month], from: lastMessage.created)
            var prependString = ""
            if nowComponents.day == messageComponents.day, nowComponents.month == messageComponents.month {
                dateFormatter.dateFormat = "HH:mm"
            }
            if nowComponents.day ?? 0 - 1 == messageComponents.day, nowComponents.month == messageComponents.month {
                prependString = "Yesterday, "
                dateFormatter.dateFormat = "HH:mm"
            }
            timeLabel.text = prependString + dateFormatter.string(from: lastMessage.created)
            unreadMessagesCountLabel.isHidden = model.unreadMessagesCount == 0
            unreadMessagesCountLabel.text = "\(model.unreadMessagesCount)"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        unreadMessagesCountLabel.layer.masksToBounds = true
        unreadMessagesCountLabel.layer.cornerRadius = unreadMessagesCountLabel.frame.height / 2
    }
}
