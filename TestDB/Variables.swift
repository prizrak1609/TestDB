//
//  Variables.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

let dateFormatter = { () -> DateFormatter in
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM HH:mm"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter
}()
