//
//  ViewController.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "newChat"), style: .plain, target: nil, action: nil)
    }
}
