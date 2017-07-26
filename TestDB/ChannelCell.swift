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

    var model: ChannelModel? {
        didSet {
            guard let model = model else { return }
            if let url = URL(string: model.lastMessage.sender.photoURLPath) {
                avatarImageView.af_setImage(withURL: url)
            }
            let sender = model.lastMessage.sender
            nameLabel.text = "\(sender.firstName) \(sender.lastName)"
            lastMessageLabel.text = model.lastMessage.text
            timeLabel.text = dateFormatter.string(from: model.lastMessage.created)
            unreadMessagesCountLabel.isHidden = model.unreadMessagesCount > 0
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
