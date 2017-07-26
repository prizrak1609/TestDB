//
//  UserModel.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import RealmSwift

final class UserModel : Object {
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var id = -1
    dynamic var photoURLPath = ""
    dynamic var userName = ""
}
