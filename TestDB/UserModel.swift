//
//  UserModel.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import AlamofireImage

final class UserModel : Object {
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var id = -1
    dynamic var photoURLPath = ""
    dynamic var userName = ""
    var avatarImage: UIImage?

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    override class func ignoredProperties() -> [String] {
        return ["fullName", "avatarImage"]
    }

    convenience init(json: JSON) {
        self.init()
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        id = json["id"].intValue
        photoURLPath = json["photo"].stringValue
        userName = json["username"].stringValue
    }

    func setAvatarImage() {
        guard let url = URL(string: photoURLPath) else { return }
        let urlRequest = URLRequest(url: url)
        ImageDownloader.default.download(urlRequest, receiptID: "", filter: nil, progress: nil, progressQueue: .main) { [weak self] response in
            guard let welf = self else { return }
            if let image = response.result.value {
                welf.avatarImage = image
            }
        }
    }
}
