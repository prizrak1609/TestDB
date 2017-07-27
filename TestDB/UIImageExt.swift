//
//  UIImageExt.swift
//  TestDB
//
//  Created by Dima Gubatenko on 26.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

extension UIImage {

    public static func from(color: UIColor, with size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        //swiftlint:disable:next force_unwrapping
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
