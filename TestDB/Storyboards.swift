//
//  Storyboards.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

enum Storyboards {

    enum Name {
        static let main = "Main"
    }

    static var main: UIViewController? {
        return UIStoryboard(name: Name.main, bundle: nil).instantiateInitialViewController()
    }
}
